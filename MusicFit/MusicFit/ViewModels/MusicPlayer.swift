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
	@Published var currentPlayingSong = Song(id: "", name: "Unknown", artistName: "Unknown Artist", artworkURL: "", genreNames: [""])
	@Published var musicPlayer = MPMusicPlayerController.systemMusicPlayer  // Use iOS/iPadOS Msuic.app
	@Published var isPlaying = false
	
	
	
	
	
	func playSong(_ song: Song) {
		currentPlayingSong = song
		musicPlayer.setQueue(with: [song.id])
		musicPlayer.play()
		isPlaying = true
	}
}
