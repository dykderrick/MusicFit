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
	let intentHandler: ContentViewIntentHandler
	let musicFitPlaylistManager: MusicFitPlaylistManager
	
	init() {
		musicManager = AppleMusicManager()
		fileHandler = FileHandler()
		musicFitPlaylistManager = MusicFitPlaylistManager(musicManager: musicManager, fileHandler: fileHandler)
		intentHandler = ContentViewIntentHandler(musicFitPlaylistManager: musicFitPlaylistManager)
	}
	
    var body: some Scene {
        WindowGroup {
			ContentView(
				musicManager: musicManager,
				fileHandler: fileHandler,
				intentHandler: intentHandler,
				musicFitPlaylistManager: musicFitPlaylistManager
			)
        }
    }
}
