//
//  MusicFitApp.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/7/22.
//

import SwiftUI

@main
struct MusicFitApp: App {
	let musicManager: AppleMusicManager
	let fileHandler: FileHandler
	let contentViewIntentHandler: ContentViewIntentHandler
	let miniPlayerIntentHandler: MiniPlayerIntentHandler
	let musicFitPlaylistManager: MusicFitPlaylistManager
	let workoutManager: WorkoutManager
	let musicPlayer: MusicPlayer
	
	init() {
		musicManager = AppleMusicManager()
		fileHandler = FileHandler()
		musicFitPlaylistManager = MusicFitPlaylistManager(musicManager: musicManager, fileHandler: fileHandler)
		contentViewIntentHandler = ContentViewIntentHandler(musicFitPlaylistManager: musicFitPlaylistManager)
		miniPlayerIntentHandler = MiniPlayerIntentHandler()
		musicPlayer = MusicPlayer(fileHandler: fileHandler, musicManager: musicManager)
		workoutManager = WorkoutManager(musicPlayer: musicPlayer)
	}
	
    var body: some Scene {
        WindowGroup {
			ContentView(
				musicManager: musicManager,
				workoutManager: workoutManager,
				musicPlayer: musicPlayer,
				miniPlayerIntentHandler: miniPlayerIntentHandler,
				fileHandler: fileHandler,
				intentHandler: contentViewIntentHandler,
				musicFitPlaylistManager: musicFitPlaylistManager
			)
        }
    }
}
