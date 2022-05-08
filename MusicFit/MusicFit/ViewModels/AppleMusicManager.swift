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
	
	@Published var currentPlayingSong = Song(id: "", name: "", artistName: "", artworkURL: "")
	@Published var musicPlayer = MPMusicPlayerController.systemMusicPlayer  // Use iOS/iPadOS Msuic.app
	@Published var isPlaying = false
	
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
		
		 let storefrontGetUrl = URL(string: "https://api.music.apple.com/v1/me/storefront")!
		 var musicRequest = URLRequest(url: storefrontGetUrl)
		 musicRequest.httpMethod = "GET"
		 musicRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
		 musicRequest.addValue(userToken, forHTTPHeaderField: "Music-User-Token")
			
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
	
	func searchAppleMusic(_ userToken: String, _ storefrontID: String, _ searchTerm: String!, completion: @escaping([Song]) -> Void) {
		var songs = [Song]()
		
		// https://developer.apple.com/documentation/applemusicapi/search_for_catalog_resources
		let searchResultGetUrl = URL(
			string: "https://api.music.apple.com/v1/catalog/\(storefrontID)/search?term=\(searchTerm.replacingOccurrences(of: " ", with: "+"))&types=songs&limit=25"
		)!  // FIXME: When type in "周杰倫", the result returns nil.
		var musicRequest = URLRequest(url: searchResultGetUrl)
		musicRequest.httpMethod = "GET"
		musicRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
		musicRequest.addValue(userToken, forHTTPHeaderField: "Music-User-Token")
		
		URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
			guard error == nil else { return }
			
			if let json = try? JSON(data: data!) {
				let result = (json["results"]["songs"]["data"]).array!
				
				for song in result {
					let attributes = song["attributes"]

					songs.append(
						Song(
							id: attributes["playParams"]["id"].string!,
							name: attributes["name"].string!,
							artistName: attributes["artistName"].string!,
							artworkURL: attributes["artwork"]["url"].string!
						)
					)
				}
				
				completion(songs)
			}
		}.resume()
	}
	
	// MARK: - Intent
	func playSong(_ song: Song) {
		currentPlayingSong = song
		musicPlayer.setQueue(with: [song.id])
		musicPlayer.play()
		isPlaying = true
	}
	
}
