//
//  ContentView.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/7/22.
//

import MediaPlayer
import StoreKit
import SwiftUI

struct ContentView: View {
	@ObservedObject var musicManager: AppleMusicManager
	@State private var selection = 0
	
    var body: some View {
		TabView(selection: $selection) {
			NowView()
				.tag(0)
				.tabItem {
					VStack {
						Image(systemName: "music.note")  // TODO: Change image
						Text("Now")
					}
				}
			
			PlaylistView()
				.tag(1)
				.tabItem {
					VStack {
						Image(systemName: "music.note")  // TODO: Change image
						Text("Playlist")
					}
				}
			
			SearchView()
				.tag(2)
				.tabItem {
					VStack {
						Image(systemName: "music.note")  // TODO: Change image
						Text("Search")
					}
				}
			
			MeView()
				.tag(3)
				.tabItem {
					VStack {
						Image(systemName: "music.note")  // TODO: Change image
						Text("Me")
					}
				}
		}
		.onAppear() {
			SKCloudServiceController.requestAuthorization { (status) in
				if status == .authorized {
					musicManager.getUserToken { userToken in
						print(userToken)
						musicManager.fetchStorefrontID(userToken: userToken) { storefrontID in
							print(storefrontID)
							musicManager.searchAppleMusic(userToken, storefrontID, "Taylor Swift") { songs in
								print(songs)
							}
						}
					}
				}
			}
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		let musicManager = AppleMusicManager()
		
        ContentView(musicManager: musicManager)
			.preferredColorScheme(.dark)
		
		ContentView(musicManager: musicManager)
			.preferredColorScheme(.light)
    }
}