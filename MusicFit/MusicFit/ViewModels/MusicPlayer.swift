//
//  MusicPlayer.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/30/22.
//

import Foundation
import MediaPlayer
import StoreKit

class MusicPlayer: ObservableObject {
	@Published var currentPlayingSong = Song(id: "", name: "Unknown", artistName: "Unknown Artist", artworkURL: "", genreNames: [""], durationInMillis: 194088)
	@Published var musicPlayer = MPMusicPlayerController.applicationMusicPlayer  // Use MusicFit Player
	@Published var isPlaying = false
	@Published var upNextSongsQueue: [Song] = []  // TODO: Is this a good design?
	
	let fileHandler: FileHandler
	let musicManager: AppleMusicManager
	let playlistManager: MusicFitPlaylistManager
	
	init(fileHandler: FileHandler, musicManager: AppleMusicManager) {
		self.fileHandler = fileHandler
		self.musicManager = musicManager
		self.playlistManager = MusicFitPlaylistManager(musicManager: musicManager, fileHandler: fileHandler)
		
		initUpNextSongsQueue()
	}
	
	// This init function is only used for previews.
	init(fileHandler: FileHandler, musicManager: AppleMusicManager, previewSong: Song) {
		self.fileHandler = fileHandler
		self.musicManager = musicManager
		self.playlistManager = MusicFitPlaylistManager(musicManager: musicManager, fileHandler: fileHandler)
		
		self.currentPlayingSong = previewSong
	}
	
	// The initial songs queue should be all songs in resting playlst
	// TODO: Add formal documentation to this function
	fileprivate func initUpNextSongsQueue() {
		self.musicManager.getUserToken { userToken in
			
			let musicFitPlaylistIdFoundResult = self.playlistManager.getMusicFitPlaylistId(musicFitStatus: .Resting)
			if !musicFitPlaylistIdFoundResult.isFound {
				// TODO: Handle error
			} else {
				self.musicManager.getLibraryPlaylistTracks(userToken, libraryPlaylistId: musicFitPlaylistIdFoundResult.playlistId) { playlistTracks in
					self.upNextSongsQueue = playlistTracks.tracks
				}
			}
		}
	}
	
	func playSong(_ song: Song) {
		currentPlayingSong = song
		musicPlayer.setQueue(with: [song.id])
		musicPlayer.play()
		isPlaying = true
	}
}
