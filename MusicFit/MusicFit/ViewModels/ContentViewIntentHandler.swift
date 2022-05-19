//
//  ContentViewIntentHandler.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/19/22.
//

import Foundation

class ContentViewIntentHandler {
	let musicFitPlaylistManager: MusicFitPlaylistManager
	
	init(musicFitPlaylistManager: MusicFitPlaylistManager) {
		self.musicFitPlaylistManager = musicFitPlaylistManager
	}
	
	func setMusicFitPlaylistMetadata(_ fileHandler: FileHandler) {
		if !fileHandler.fileInDocumentDirectory(file: "MusicFitPlaylists.json") {
			fileHandler.copyFileFromBundleToDocumentsFolder(sourceFile: "MusicFitPlaylists.json")
		}
	}
	
	func setMusicFitPlaylistsAvailability(_ musicManager: AppleMusicManager) {
		for musicFitStatus in MusicFitStatus.allCases {
			self.musicFitPlaylistManager.checkMusicFitPlaylistAvailability(musicFitStatus: musicFitStatus) { isAvailable in
				if !isAvailable {
					self.musicFitPlaylistManager.setMusicFitPlaylistId(musicFitStatus: musicFitStatus, playlistId: "")
					print("PREPARE TO SET \(musicFitStatus) TO NIL: \(self.musicFitPlaylistManager.getMusicFitPlaylistId(musicFitStatus: musicFitStatus))")
				}
			}
		}
	}
}
