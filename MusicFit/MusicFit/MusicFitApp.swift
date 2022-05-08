//
//  MusicFitApp.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/7/22.
//

import SwiftUI

@main
struct MusicFitApp: App {
	let musicManager = AppleMusicManager()
	
    var body: some Scene {
        WindowGroup {
            ContentView(musicManager: musicManager)
        }
    }
}
