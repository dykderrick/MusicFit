//
//  MusicFitPlaylistManager.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/19/22.
//

import Foundation

class MusicFitPlaylistManager: ObservableObject {
	let musicManager: AppleMusicManager
	let fileHandler: FileHandler
	
	@Published var musicFitPlaylistTrackCount = [MusicFitStatus:Int]()
	
	init(musicManager: AppleMusicManager, fileHandler: FileHandler) {
		self.musicManager = musicManager
		self.fileHandler = fileHandler
		
		// init playlist count dict
		MusicFitStatus.allCases.forEach {
			musicFitPlaylistTrackCount[$0] = 0
		}
	}
	
	/// Uses "MusicFitPlaylists.json" file to fetch a corresponding playlist id for a specific MusicFit Status.
	/// - Parameters:
	///	  - musicFitStatus: a ``MusicFitStatus`` enumeration.
	/// - Returns: a tuple of (Bool, String) representing getter result.
	/// Bool value indicates if the playlist is found or not. String value indicates the found playlist id. If the Bool value is false, the String value will be "".
	func getMusicFitPlaylistId(ofStatus musicFitStatus: MusicFitStatus) -> (isFound: Bool, playlistId: String) {
		let json = self.fileHandler.getJSONDataFromFile(fileName: "MusicFitPlaylists.json")
			
		if let json = json {
			let playlistId = json["\(musicFitStatus.rawValue)PlaylistId"].stringValue
				
			return playlistId == "" ? (false, "") : (true, playlistId)
		}
		
		
		return (false, "")
	}
	
	func setMusicFitPlaylistId(musicFitStatus: MusicFitStatus, playlistId: String) {
		let json = self.fileHandler.getJSONDataFromFile(fileName: "MusicFitPlaylists.json")

		if var json = json {
			json["\(musicFitStatus)PlaylistId"].string = playlistId
				
			if let encodedData = try? JSONEncoder().encode(json) {
				self.fileHandler.saveJSONDataToFile(json: encodedData, fileName: "MusicFitPlaylists.json")
			}
		}
	}
	
	func musicFitPlaylistsAreEmpty() -> Bool {
		var isFound = false
		
		MusicFitStatus.allCases.forEach {
			isFound = isFound || getMusicFitPlaylistId(ofStatus: $0).isFound
		}
		
		return !isFound
	}
	
	func initMusicFitPlaylists(completion: @escaping(Bool) -> Void) {
		self.musicManager.getUserToken { userToken in
			self.musicManager.createLibraryPlaylistFolder(userToken, folderName: "MusicFit") { isCreated, folderId in
				if !isCreated {
					completion(false)
				}
				
				// TODO: Change song catelog ids.
				self.musicManager.createPlaylistWithCatelogSongs(userToken, playlistName: "Running", playlistDescription: "This is MusicFit playlist for running.", playlistFolderId: folderId, songCatelogIds: ["1450695739", "1369380479"]) {runningPlaylist in
					// TODO: Handle Running Playlist
					print(runningPlaylist)
					self.setMusicFitPlaylistId(musicFitStatus: .Running, playlistId: runningPlaylist.id)
					print("RUNNING PLAYLIST ID: \(self.getMusicFitPlaylistId(ofStatus: .Running))")
				}
				
				// TODO: Change song catelog ids.
				self.musicManager.createPlaylistWithCatelogSongs(userToken, playlistName: "Walking", playlistDescription: "This is MusicFit playlist for walking.", playlistFolderId: folderId, songCatelogIds: ["1544494722", "1544491234"]) { walkingPlaylist in
					//TODO: Handle Walking Playlist
					print(walkingPlaylist)
					self.setMusicFitPlaylistId(musicFitStatus: .Walking, playlistId: walkingPlaylist.id)
					print("WALKING PLAYLIST ID: \(self.getMusicFitPlaylistId(ofStatus: .Walking))")
				}
				
				// TODO: Change song catelog ids.
				self.musicManager.createPlaylistWithCatelogSongs(userToken, playlistName: "Resting", playlistDescription: "This is MusicFit playlist for resting.", playlistFolderId: folderId, songCatelogIds: ["1590368453", "1452859410"]) { restingPlaylist in
					//TODO: Handle Resting Playlist
					print(restingPlaylist)
					self.setMusicFitPlaylistId(musicFitStatus: .Resting, playlistId: restingPlaylist.id)
					print("RESTING PLAYLIST ID: \(self.getMusicFitPlaylistId(ofStatus: .Resting))")
				}
				
				completion(true)
			}
		}
	}
	
	func checkMusicFitPlaylistAvailability(musicFitStatus: MusicFitStatus, completion: @escaping(Bool) -> Void) {
		let playlistFoundResult = self.getMusicFitPlaylistId(ofStatus: musicFitStatus)
		
		if playlistFoundResult.isFound {
			self.musicManager.getUserToken { userToken in
				self.musicManager.getLibraryPlaylistData(userToken, catelogPlaylistId: playlistFoundResult.playlistId) { playlistGetResult in
					completion(playlistGetResult.playlistExists)
				}
			}
		} else {
			completion(false)
		}
	}
	
	func prepareMusicFitPlaylistTracks(musicFitStatus: MusicFitStatus, completion: @escaping((isPrepared: Bool, playlistTracks: PlaylistTracks)) -> Void) {
		let musicFitPlaylistIdGetResult = self.getMusicFitPlaylistId(ofStatus: musicFitStatus)
		
		if !musicFitPlaylistIdGetResult.isFound {
			completion((false, PlaylistTracks(playlistId: "", tracks: [Song(id: "", name: "", artistName: "", artworkURL: "", genreNames: [""], durationInMillis: 194088)])))
		} else {
			self.musicManager.getUserToken { userToken in
				self.musicManager.getLibraryPlaylistTracks(userToken, libraryPlaylistId: musicFitPlaylistIdGetResult.playlistId) { playlistTracks in
					self.musicFitPlaylistTrackCount[musicFitStatus] = playlistTracks.tracks.count // set playlist track count
					completion((true, playlistTracks))
				}
			}
		}
	}
}
