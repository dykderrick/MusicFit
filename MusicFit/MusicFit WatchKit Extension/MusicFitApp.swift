//
//  MusicFitApp.swift
//  MusicFit WatchKit Extension
//
//  Created by Derrick Ding on 5/7/22.
//

import SwiftUI

@main
struct MusicFitApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
