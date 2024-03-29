//
//  AppleMusicManager.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/7/22.
//

import MediaPlayer
import SwiftyJSON
import Alamofire
import StoreKit

// FIXME: Can we use generics and protocols to shrink these bunch of functions which mostly act the same thing?
class AppleMusicManager: ObservableObject {
    @Published var appleMusicStorefrontID: String?
    
    private let fileHandler: FileHandler  // Handle JSON File
	
//    @Published var currentPlayingSong = Song(id: "", name: "", artistName: "", artworkURL: "", genreNames: [""])
//	@Published var musicPlayer = MPMusicPlayerController.systemMusicPlayer  // Use iOS/iPadOS Msuic.app
//	@Published var isPlaying = false
    
    init() {
        self.appleMusicStorefrontID = nil
        self.fileHandler = FileHandler()
    }
    
    /// Set `Published` ``appleMusicStorefrontID`` in ``AppleMusicManager``.
    func setAppleMusicStorefrontID() async {
        if let storeFrontID = await AppleMusicAPIBase.getAppleMusicStorefrontID() {
            await MainActor.run {
                self.appleMusicStorefrontID = storeFrontID
            }
        } else {
            print("Storefront ID Fetch Failed.")
        }
    }
    
    // MARK: - Rewritten
	// See Also: https://stackoverflow.com/questions/65057320/skcloudservicecontroller-requestusertoken-freezes-on-ios-14-2
	// TODO: Add formal documentation to this function
	func getUserToken(completion: @escaping(_ userToken: String) -> Void) -> Void {
		SKCloudServiceController().requestUserToken(forDeveloperToken: Configs.DEVELOPER_TOKEN) { (userToken, error) in
			guard error == nil else { return }
			completion(userToken!)
		}
	}
    
    // MARK: - Rewritten
	// storefrontID is an ISO 3166 alpha-2 country code
	// TODO: Add formal documentation to this function
	func fetchStorefrontID(userToken: String, completion: @escaping(String) -> Void) {
        let musicRequest = wrapMusicRequest(
			urlSting: "\(Configs.APPLE_MUSIC_API_URL)/v1/me/storefront",
			userToken: userToken,
			httpMethod: "GET",
			parameters: nil
		)

		musicRequest.validate().responseDecodable(of: JSON.self) { response in
			switch response.result {
			case .success(let value):
				completion(JSON(value)["data"].array![0]["id"].stringValue)

			case .failure(let error):
				print(error)
			}
		}.resume()
	}
	
	private func wrapMusicRequest(urlSting: String, userToken: String, httpMethod: String, parameters: [String: Any]?) -> Alamofire.DataRequest {
		
		let headers: HTTPHeaders = [
			"Authorization": "Bearer \(Configs.DEVELOPER_TOKEN)",
			"Music-User-Token": userToken
		]
		
		switch httpMethod {
		case "GET":
			return AF.request(urlSting, method: .get, headers: headers)
		case "POST":
			guard let requestParameters = parameters else { return AF.request(urlSting) }
			return AF.request(urlSting, method: .post, parameters: requestParameters, encoding: JSONEncoding.default, headers: headers)
		default:
			return AF.request(urlSting)  // TODO: may have side effect
		}
	}
}

// MARK: - Song
extension AppleMusicManager {
    // MARK: - Rewritten
	// See Also: https://developer.apple.com/documentation/applemusicapi/get_a_catalog_song
	// TODO: Add formal documentation to this function
	func getCatelogSong(_ userToken: String, storefrontId: String, catelogSongId: String, completion: @escaping(Song) -> Void) {
		let musicRequest = wrapMusicRequest(
			urlSting: "\(Configs.APPLE_MUSIC_API_URL)/v1/catalog/\(storefrontId)/songs/\(catelogSongId)",
			userToken: userToken,
			httpMethod: "GET",
			parameters: nil
		)
		
		musicRequest.validate().responseDecodable(of: JSON.self) { response in
			switch response.result {
			case .success(let value):
				let result = (JSON(value)["data"]).array![0]
				let attributes = result["attributes"]
				
				// FIXME: This snippet is way too ugly.
				// FIXME: This snippet is redundant.
				let genreNamesArray = (attributes["genreNames"]).array!
				var genreNames = [String]()
				for genreName in genreNamesArray {
					genreNames.append(genreName.stringValue)
				}
				
				completion(
					Song(
						id: 			  result["id"].stringValue,
						name: 			  attributes["name"].stringValue,
						artistName: 	  attributes["artistName"].stringValue,
						artworkURL: 	  attributes["artwork"]["url"].stringValue,
						genreNames: 	  genreNames,
						durationInMillis: attributes["durationInMillis"].intValue
					)
				)
				
			case .failure(let error):
				print(error)
			}
		}.resume()
	}
	
	// MARK: - Rewritten
	// See Also: https://developer.apple.com/documentation/applemusicapi/get_a_personal_song_rating
	// TODO: Add formal documentation to this function
	func getSongRating(_ userToken: String, id songIdentifier: String, completion: @escaping(Rating) -> Void) {
		var rating = Rating.unset
		
		let musicRequest = wrapMusicRequest(
			urlSting: "\(Configs.APPLE_MUSIC_API_URL)/v1/me/ratings/songs/\(songIdentifier)",
			userToken: userToken,
			httpMethod: "GET",
			parameters: nil
		)
		
		musicRequest.validate().responseDecodable(of: JSON.self) { response in
			// TODO: handle Apple Music API capacity
			/*
			 Apple Music API limits the number of requests your app can make using a developer token within a specific period of time.
			 If this limit is exceeded, you’ll temporarily receive 429 Too Many Requests error responses for requests that use the token.
			 This error resolves itself shortly after the request rate has reduced.
			 
			 See Also: https://developer.apple.com/documentation/applemusicapi/generating_developer_tokens
			 */
			
			switch response.result {
			case .success(let value):
				let result = (JSON(value)["data"]).array![0]["attributes"]["value"].intValue
	
				rating = (result == 1) ? Rating.likes : Rating.dislikes

				completion(rating)
				
			case .failure(_):
				// The most ugly design in Apple Music API: when the user hasn't set a song's rating, the API responses a 404.
				// See Also: https://stackoverflow.com/questions/53767247/getting-a-rating-for-a-song-with-apple-music-api
				completion(Rating.unset)
			}
		}.resume()
	}
	
	// See Also: https://developer.apple.com/documentation/applemusicapi/search_for_catalog_resources
	// TODO: Add formal documentation to this function
	func searchAppleMusic(_ userToken: String, _ storefrontID: String, _ searchTerm: String!, completion: @escaping([Song]) -> Void) {
		var songs = [Song]()
		
		// FIXME: When type in "周杰倫", the result returns nil.
		let musicRequest = wrapMusicRequest(
			urlSting: "\(Configs.APPLE_MUSIC_API_URL)/v1/catalog/\(storefrontID)/search?term=\(searchTerm.replacingOccurrences(of: " ", with: "+"))&types=songs&limit=5",
			userToken: userToken,
			httpMethod: "GET",
			parameters: nil
		)
		
		musicRequest.validate().responseDecodable(of: JSON.self) { response in
			switch response.result {
			case .success(let value):
				let result = (JSON(value)["results"]["songs"]["data"]).array!
				
				for song in result {
					let attributes = song["attributes"]          // this song's attributes
					let songIdentifier = song["id"].stringValue  // this song's unique id
					
					// FIXME: This snippet is way too ugly.
					let genreNamesArray = (attributes["genreNames"]).array!
					var genreNames = [String]()
					for genreName in genreNamesArray {
						genreNames.append(genreName.stringValue)
					}
					
					songs.append(
						Song(
							id: songIdentifier,
							name: attributes["name"].string!,
							artistName: attributes["artistName"].string!,
							artworkURL: attributes["artwork"]["url"].string!,
							genreNames: genreNames,
							durationInMillis: attributes["durationInMillis"].intValue
						)
					)
				}
				
				completion(songs)
			case .failure(let error):
				print(error)
			}
		}.resume()
	}
}

// MARK: - Playlist
extension AppleMusicManager {
    // MARK: - Rewritten
	// See Also: https://developer.apple.com/documentation/applemusicapi/get_all_library_playlists
	// TODO: Add formal documentation to this function
	func getAllLibraryPlaylists(_ userToken: String, completion: @escaping([Playlist]) -> Void) {
		var playlists = [Playlist]()
		
		let musicRequest = wrapMusicRequest(
			urlSting: "\(Configs.APPLE_MUSIC_API_URL)/v1/me/library/playlists",
			userToken: userToken,
			httpMethod: "GET",
			parameters: nil
		)
		
		musicRequest.validate().responseDecodable(of: JSON.self) { response in
			switch response.result {
			case .success(let value):
				let dataArray = (JSON(value)["data"]).array!
				
				for playlist in dataArray {
					let attributes = playlist["attributes"]
					
					playlists.append(
						Playlist(
							id: playlist["id"].stringValue,
							name: attributes["name"].stringValue,
							description: attributes["description"]["standard"].stringValue,
							isPublic: attributes["isPublic"].boolValue,
							canEdit: attributes["canEdit"].boolValue,
							dateAdded: ISO8601DateFormatter().date(from: attributes["dateAdded"].stringValue) ?? Date(),
							artworkURL: attributes["artwork"]["url"].stringValue
						)
					)
				}
				
				completion(playlists)
			case .failure(let error):
				print(error)
			}
		}.resume()
	}
	
    // MARK: - Rewritten
	// See Also: https://developer.apple.com/documentation/applemusicapi/get_a_library_playlist
	// TODO: Add formal documentation to this function
	func getLibraryPlaylistData(_ userToken: String, catelogPlaylistId: String, completion: @escaping((playlistExists: Bool, playlist: Playlist)) -> Void) {
		let musicRequest = wrapMusicRequest(
			urlSting: "\(Configs.APPLE_MUSIC_API_URL)/v1/me/library/playlists/\(catelogPlaylistId)",
			userToken: userToken,
			httpMethod: "GET",
			parameters: nil
		)
		
		musicRequest.validate().responseDecodable(of: JSON.self) { response in
			switch response.result {
			case .success(let value):
				let metadata = (JSON(value)["data"]).array![0]
				let attributes = (JSON(value)["data"]).array![0]["attributes"]
				let playlistExists = attributes["name"].string != nil  // If the playlist doesn't exist, the attributes won't have a name field.
				
				if metadata["id"].stringValue == "p.7PkeL3Qu08mQKXQ" {
					print("DEBUG HERE")
				}
				
				if playlistExists {
					completion(
						(
							true,
							Playlist(
								id: metadata["id"].stringValue,
								name: attributes["name"].stringValue,
								description: attributes["description"]["standard"].stringValue,
								isPublic: attributes["isPublic"].boolValue,
								canEdit: attributes["canEdit"].boolValue,
								dateAdded: ISO8601DateFormatter().date(from: attributes["dateAdded"].stringValue) ?? Date(),
								artworkURL: attributes["artwork"]["url"].stringValue
							)
						)
					)
				} else {
					completion((false, Playlist(id: "", name: "", description: "", isPublic: false, canEdit: false, dateAdded: Date(), artworkURL: "")))
				}
			case .failure(let error):
				print(error)
			}
		}.resume()
	}
	
	// See Also: https://developer.apple.com/documentation/applemusicapi/get_a_library_playlist_s_relationship_directly_by_name
	// TODO: Add formal documentation to this function
	func getLibraryPlaylistTracks(_ userToken: String, libraryPlaylistId: String, completion: @escaping(PlaylistTracks) -> Void) {
		let musicRequest = wrapMusicRequest(
			urlSting: "\(Configs.APPLE_MUSIC_API_URL)/v1/me/library/playlists/\(libraryPlaylistId)/tracks",
			userToken: userToken,
			httpMethod: "GET",
			parameters: nil
		)
		
		musicRequest.validate().responseDecodable(of: JSON.self) { response in
			switch response.result {
			case .success(let value):
				let metaSongs = (JSON(value)["data"]).array!
				
				var songs = [Song]()
				
				for metaSong in metaSongs {
					let attributes = metaSong["attributes"]
					let songIdentifier = attributes["playParams"]["catalogId"].stringValue
//					var songRating = Song.Rating.unset
					
					// FIXME: This snippet is way too ugly.
					let genreNamesArray = (attributes["genreNames"]).array!
					var genreNames = [String]()
					for genreName in genreNamesArray {
						genreNames.append(genreName.stringValue)
					}
					
					/*
					// Request to the user's rating on this song
					self.getSongRating(userToken, id: songIdentifier) { rating in
						songRating = rating
					}
					 */
					
					
					songs.append(
						Song(
							id: songIdentifier,
							name: attributes["name"].stringValue,
							artistName: attributes["artistName"].stringValue,
							artworkURL: attributes["artwork"]["url"].stringValue,
							genreNames: genreNames,
							durationInMillis: attributes["durationInMillis"].intValue
						)
					)
				}
				
				completion(
					PlaylistTracks(
						playlistId: libraryPlaylistId,
						tracks: songs
					)
				)
			case .failure(let error):
				print(error)
			}
		}.resume()
	}
	
    // MARK: - Rewritten
	// See Also: https://developer.apple.com/documentation/applemusicapi/create_a_new_library_playlist
	// TODO: Add formal documentation to this function
	func createPlaylistWithCatelogSongs(_ userToken: String, playlistName: String, playlistDescription: String, playlistFolderId: String, songCatelogIds: [String], completion: @escaping(Playlist) -> Void) {
		
		var tracksData = [[String: String]]()
		for songCatelogId in songCatelogIds {
			tracksData.append([
				"id": songCatelogId,
				"type": "songs"
			])
		}
		
		let musicRequest = wrapMusicRequest(
			urlSting: "\(Configs.APPLE_MUSIC_API_URL)/v1/me/library/playlists",
			userToken: userToken,
			httpMethod: "POST",
			parameters: [
				"attributes": [
					"name": playlistName,
					"description": playlistDescription
				],
				"relationships": [
					"tracks": ["data": tracksData],
					"parent": [
						"data": [
							[
								"id": playlistFolderId,
								"type": "library-playlist-folders"
							]
						]
					]
				]
			]
		)
		
		musicRequest.validate().responseDecodable(of: JSON.self) { response in
			debugPrint(response)
			
			switch response.result {
			case .success(let value):
				let json = JSON(value)
				print("JSON: \(json)")
				
				let result = json["data"].array![0]
				let attributes = result["attributes"]
				
				completion(
					Playlist(
						id: result["id"].stringValue,
						name: attributes["name"].stringValue,
						description: attributes["description"]["standard"].stringValue,
						isPublic: attributes["isPublic"].boolValue,
						canEdit: attributes["canEdit"].boolValue,
						dateAdded: ISO8601DateFormatter().date(from: attributes["dateAdded"].stringValue) ?? Date(),
						artworkURL: ""  // TODO: Can we add custom artwork in playlist creation?
					)
				)

			case .failure(let error):
				print(error)
			}
		}.resume()
	}
	
    // MARK: - Rewritten
	// See Also: https://developer.apple.com/documentation/applemusicapi/create_a_new_library_playlist_folder
	// TODO: Add formal documentation to this function
	func createLibraryPlaylistFolder(_ userToken: String, folderName: String, completion: @escaping((Bool, String)) -> Void) {
		let musicRequest = wrapMusicRequest(
			urlSting: "\(Configs.APPLE_MUSIC_API_URL)/v1/me/library/playlist-folders",
			userToken: userToken,
			httpMethod: "POST",
			parameters: [
				"attributes": [
					"name": folderName
				],
				"relationships": [
					"parent": [
						"data": [
							[
								"id": "p.playlistsroot",
								"type": "library-playlist-folders"
							]
						]
					]
				]
			]
		)
		
		musicRequest.validate().responseDecodable(of: JSON.self) { response in
			switch response.result {
			case .success(let value):
				let createdFolderId = JSON(value)["data"].array![0]["id"].stringValue
				
				completion((true, createdFolderId))
			case .failure(let error):
				print(error)
				completion((false, ""))
			}
		}.resume()
	}
}

// MARK: - Intent
extension AppleMusicManager {
	func playSong(_ song: Song) {
//		currentPlayingSong = song
//		musicPlayer.setQueue(with: [song.id])
//		musicPlayer.play()
//		isPlaying = true
	}
}
