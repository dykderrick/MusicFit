//
//  PlaylistView.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/7/22.
//

import SwiftUI

struct PlaylistView: View {
	@ObservedObject var musicManager: AppleMusicManager
	@State private var playlistCount = [0, 1, 2]
	@State private var showingPlaylistCreationSheet = false
	let musicFitPlaylistManager: MusicFitPlaylistManager
	
    var body: some View {
		NavigationView {
			VStack {
				List {
					ForEach(playlistCount, id:\.self) { num in
						PlaylistItem()
							.listRowBackground(Color.black)
					}
					.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
				}
				.navigationTitle("Playlist")
				
				MiniPlayer()
				Spacer()
			}
		}
		// Showing a playlist creation sheet if the user has empty playlists for MusicFit.
		.onAppear() {
			showingPlaylistCreationSheet = musicFitPlaylistManager.musicFitPlaylistsAreEmpty()
		}
		.sheet(isPresented: $showingPlaylistCreationSheet) {
			PlaylistCreationSheet(musicManager: musicManager, musicFitPlaylistManager: musicFitPlaylistManager)
		}
		
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
		let musicManager = AppleMusicManager()
		let fileHandler = FileHandler()
		let musicFitPlaylistManager = MusicFitPlaylistManager(musicManager: musicManager, fileHandler: fileHandler)
		
		PlaylistView(musicManager: musicManager, musicFitPlaylistManager: musicFitPlaylistManager)
			.preferredColorScheme(.dark)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
		
		PlaylistView(musicManager: musicManager, musicFitPlaylistManager: musicFitPlaylistManager)
			.preferredColorScheme(.dark)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}
