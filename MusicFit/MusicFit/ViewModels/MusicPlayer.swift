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
	// MARK: - Published variables
	@Published var currentPlayingSong = Song(id: "myID", name: "Unknown", artistName: "Unknown Artist", artworkURL: "", genreNames: [""], durationInMillis: 194088)
	@Published var player = MPMusicPlayerController.applicationQueuePlayer  // Use MusicFit Player
	@Published var isPlaying = false
	@Published var upNextSongsQueue: [Song] = []  // TODO: Is this a good design?
	
	// MARK: - ViewModel variables
	let fileHandler: FileHandler
	let musicManager: AppleMusicManager
	let playlistManager: MusicFitPlaylistManager
	
	// MARK: - Initiators
	init(fileHandler: FileHandler, musicManager: AppleMusicManager) {
		self.fileHandler = fileHandler
		self.musicManager = musicManager
		self.playlistManager = MusicFitPlaylistManager(musicManager: musicManager, fileHandler: fileHandler)
		
		// Preparing the player at the initialization stage can reduce latency
		self.player.prepareToPlay()
		
		initUpNextSongsQueue()
	}
	
	// This init function is only used for previews.
	// TODO: Add formal documentation to this init.
	init(fileHandler: FileHandler, musicManager: AppleMusicManager, previewSong: Song) {
		self.fileHandler = fileHandler
		self.musicManager = musicManager
		self.playlistManager = MusicFitPlaylistManager(musicManager: musicManager, fileHandler: fileHandler)
		
		self.currentPlayingSong = previewSong
	}
	
	// MARK: - Functions
	
	fileprivate func getUpNextSongIds() -> [String] {
		var songIds: [String] = []
		
		self.upNextSongsQueue.forEach { song in
			songIds += [song.id]
		}
		
		return songIds
	}
	
	// The initial songs queue should be all songs in resting playlst
	// TODO: Add formal documentation to this function
	fileprivate func initUpNextSongsQueue() {
		self.musicManager.getUserToken { userToken in
			
			let musicFitPlaylistIdFoundResult = self.playlistManager.getMusicFitPlaylistId(ofStatus: .Resting)
			if !musicFitPlaylistIdFoundResult.isFound {
				// TODO: Handle error
			} else {
				self.musicManager.getLibraryPlaylistTracks(userToken, libraryPlaylistId: musicFitPlaylistIdFoundResult.playlistId) { playlistTracks in
					self.upNextSongsQueue = playlistTracks.tracks
					self.initPlayer()
				}
			}
		}
	}
	
	// Put all up next songs to the player queue.
	// TODO: Add formal documentation to this function.
	fileprivate func initPlayer() {
		player.setQueue(with: getUpNextSongIds())
	}
	
	// This function will remove all up next songs,
	// and add all songs from a specific MusicFit playlist to the queue.
	// TODO: Add formal documentation to this function.
	func modifyUpNextSongsQueueByStatus(_ musicFitStatus: MusicFitStatus) {
		if upNextSongsQueue.count == 0 {
			initUpNextSongsQueue()  // FIXME: Maybe there will be bugs.
		} else {
			upNextSongsQueue.removeAll()
			
			self.musicManager.getUserToken() { userToken in
				let musicFitPlaylistIdFoundResult = self.playlistManager.getMusicFitPlaylistId(ofStatus: musicFitStatus)
				if !musicFitPlaylistIdFoundResult.isFound {
					// TODO: Handle error
				} else {
					self.musicManager.getLibraryPlaylistTracks(
						userToken,
						libraryPlaylistId: musicFitPlaylistIdFoundResult.playlistId
					) { playlistTracks in
						self.upNextSongsQueue += playlistTracks.tracks  // Append tracks to up next songs queue
						
						self.player.perform(queueTransaction: { queue in
							let afterItem = queue.items[0]  // current playing song
							
							// Remove all remaining songs in the queue
							for i in 1 ... queue.items.count - 1 {
								queue.remove(queue.items[i])
							}
							
							// Insert all songs in the upNextSongsQueue
							queue.insert(MPMusicPlayerStoreQueueDescriptor(storeIDs: self.getUpNextSongIds()), after: afterItem)
							
						}, completionHandler: { (queue, error) in
							// TODO: Handle the modified queue and error
							print("QUEUE: \(queue)")
						})
						
						
					}
				}
			}
		}
	}
	
	
	// MARK: - Intents
	func playerPlay() {
		// Play the player.
		player.play()
		
		// Set currentPlaylingSong variable
		self.musicManager.getUserToken { userToken in
			self.musicManager.fetchStorefrontID(userToken: userToken) { storefrontId in
				self.musicManager.getCatelogSong(
					userToken,
					storefrontId: storefrontId,
					catelogSongId: self.player.nowPlayingItem?.playbackStoreID ?? "") { song in
						self.currentPlayingSong = song
					}
			}
		}
	}
	
	func playerPause() {
		// Pause the player.
		player.pause()
	}
	
}
