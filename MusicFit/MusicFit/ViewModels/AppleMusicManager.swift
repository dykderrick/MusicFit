//
//  AppleMusicManager.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/7/22.
//

import MediaPlayer
import SwiftyJSON
import StoreKit

class AppleMusicManager: ObservableObject {
	private let developerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiIsImtpZCI6IjVRTEQ3VFY0SDQifQ.eyJpc3MiOiJHODJDTE5WQTY0IiwiZXhwIjoxNjY3Njg0MDY1LCJpYXQiOjE2NTE5MTYwNjV9.KuxfoPON751gB-_-xWuucC4ppPTPYQs6_yznr8GC6FTxJfsnvIbGeVvspd6n1yZXtbMCr_vGYwlyouymI8biHg"  // FIXME: Can we hide it somehow?
    private let apiRootPath = "https://api.music.apple.com/v1"  // Apple Music API Root Path
	
    @Published var currentPlayingSong = Song(id: "", name: "", artistName: "", artworkURL: "", genreNames: [""])
	@Published var musicPlayer = MPMusicPlayerController.systemMusicPlayer  // Use iOS/iPadOS Msuic.app
	@Published var isPlaying = false
	
    
    // FIXME: Can we use generics and protocols to shrink these bunch of functions which mostly act the same thing?
    
    
	// See Also: https://stackoverflow.com/questions/65057320/skcloudservicecontroller-requestusertoken-freezes-on-ios-14-2
	// TODO: Add formal documentation to this function
	func getUserToken(completion: @escaping(_ userToken: String) -> Void) -> Void {
		SKCloudServiceController().requestUserToken(forDeveloperToken: developerToken) { (userToken, error) in
			guard error == nil else { return }
			completion(userToken!)
		}
	}
	
	// storefrontID is an ISO 3166 alpha-2 country code
	// TODO: Add formal documentation to this function
	func fetchStorefrontID(userToken: String, completion: @escaping(String) -> Void) {
		 var storefrontID: String!
		
        let musicRequest = wrapMusicRequest(
            urlString: "\(apiRootPath)/me/storefront",
            userToken: userToken,
            developerToken: developerToken
        )
			
		 URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
			  guard error == nil else { return }
				
			  if let json = try? JSON(data: data!) {
				  let result = (json["data"]).array!
				  let id = (result[0].dictionaryValue)["id"]!
				  storefrontID = id.stringValue
				  completion(storefrontID)
			  }
		 }.resume()
	}
	
    // See Also: https://developer.apple.com/documentation/applemusicapi/search_for_catalog_resources
    // TODO: Add formal documentation to this function
	func searchAppleMusic(_ userToken: String, _ storefrontID: String, _ searchTerm: String!, completion: @escaping([Song]) -> Void) {
		var songs = [Song]()
		
        
        // FIXME: When type in "周杰倫", the result returns nil.
        let musicRequest = wrapMusicRequest(
            urlString: "\(apiRootPath)/catalog/\(storefrontID)/search?term=\(searchTerm.replacingOccurrences(of: " ", with: "+"))&types=songs&limit=25",
            userToken: userToken,
            developerToken: developerToken
        )
		
		URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
			guard error == nil else { return }
			
			if let json = try? JSON(data: data!) {
				let result = (json["results"]["songs"]["data"]).array!
				
				for song in result {
					let attributes = song["attributes"]
                    
                    // FIXME: This snippet is way too ugly.
                    let genreNamesArray = (attributes["genreNames"]).array!
                    var genreNames = [String]()
                    for genreName in genreNamesArray {
                        genreNames.append(genreName.stringValue)
                    }
                    
					songs.append(
						Song(
							id: attributes["playParams"]["id"].string!,
							name: attributes["name"].string!,
							artistName: attributes["artistName"].string!,
							artworkURL: attributes["artwork"]["url"].string!,
                            genreNames: genreNames
						)
					)
				}
				
				completion(songs)
			}
		}.resume()
	}
    
    // See Also: https://developer.apple.com/documentation/applemusicapi/get_all_library_playlists
    // TODO: Add formal documentation to this function
    func getAllUserPlaylists(_ userToken: String, completion: @escaping([Playlist]) -> Void) {
        var playlists = [Playlist]()
        
        
        let musicRequest = wrapMusicRequest(
            urlString: "\(apiRootPath)/me/library/playlists",
            userToken: userToken,
            developerToken: developerToken
        )
        
        
        URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
            guard error == nil else { return }
            
            if let json = try? JSON(data: data!) {
                let dataArray = (json["data"]).array!
                
                for playlist in dataArray {
                    let atrributes = playlist["attributes"]
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                    
                    playlists.append(
                        Playlist(
                            id: playlist["id"].stringValue,
                            name: atrributes["name"].stringValue,
                            description: "",
                            isPublic: atrributes["isPublic"].boolValue,
                            canEdit: atrributes["canEdit"].boolValue,
                            dateAdded: formatter.date(from: atrributes["dateAdded"].stringValue) ?? Date(),
                            artworkURL: ""
                        )
                    )
                }
                
                completion(playlists)
            }
        }.resume()
    }
    
    // See Also: https://developer.apple.com/documentation/applemusicapi/get_a_library_playlist
    // TODO: Add formal documentation to this function
    func getPlaylistData(_ userToken: String, playlistId: String, completion: @escaping(Playlist) -> Void) {
        let musicRequest = wrapMusicRequest(
            urlString: "\(apiRootPath)/me/library/playlists/\(playlistId)",
            userToken: userToken,
            developerToken: developerToken
        )
        
        URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
            guard error == nil else { return }
            
            if let json = try? JSON(data: data!) {
                let metadata = (json["data"]).array![0]
                let attributes = (json["data"]).array![0]["attributes"]
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                
                completion(
                    Playlist(
                        id: metadata["id"].stringValue,
                        name: attributes["name"].stringValue,
                        description: attributes["description"]["standard"].stringValue,
                        isPublic: attributes["isPublic"].boolValue,
                        canEdit: attributes["canEdit"].boolValue,
                        dateAdded: dateFormatter.date(from: attributes["dateAdded"].stringValue) ?? Date(),
                        artworkURL: attributes["artwork"]["url"].stringValue
                    )
                )
            }
        }.resume()
    }
    
    // See Also: https://developer.apple.com/documentation/applemusicapi/get_a_library_playlist_s_relationship_directly_by_name
    // TODO: Add formal documentation to this function
    func getPlaylistTracks(_ userToken: String, playlistId: String, completion: @escaping(PlaylistTracks) -> Void) {
        let musicRequest = wrapMusicRequest(
            urlString: "\(apiRootPath)/me/library/playlists/\(playlistId)/tracks",
            userToken: userToken,
            developerToken: developerToken
        )
        
        URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
            guard error == nil else { return }
            
            if let json = try? JSON(data: data!) {
                let metaSongs = (json["data"]).array!
                
                var songs = [Song]()
                
                for metaSong in metaSongs {
                    let attributes = metaSong["attributes"]
                    
                    // FIXME: This snippet is way too ugly.
                    let genreNamesArray = (attributes["genreNames"]).array!
                    var genreNames = [String]()
                    for genreName in genreNamesArray {
                        genreNames.append(genreName.stringValue)
                    }
                    
                    songs.append(
                        Song(
                            id: attributes["playParams"]["catalogId"].stringValue,
                            name: attributes["name"].stringValue,
                            artistName: attributes["artistName"].stringValue,
                            artworkURL: attributes["artwork"]["url"].stringValue,
                            genreNames: genreNames
                        )
                    )
                }
                
                completion(
                    PlaylistTracks(
                        playlistId: playlistId,
                        trucks: songs
                    )
                )
            }
            
        }.resume()
    }
    
    private func wrapMusicRequest(urlString: String, userToken: String, developerToken: String) -> URLRequest {
        let url = URL(string: urlString)!
        
        var musicRequest = URLRequest(url: url)
        musicRequest.httpMethod = "GET"
        musicRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
        musicRequest.addValue(userToken, forHTTPHeaderField: "Music-User-Token")
        
        return musicRequest
    }
    
	// MARK: - Intent
	func playSong(_ song: Song) {
		currentPlayingSong = song
		musicPlayer.setQueue(with: [song.id])
		musicPlayer.play()
		isPlaying = true
	}
	
}
