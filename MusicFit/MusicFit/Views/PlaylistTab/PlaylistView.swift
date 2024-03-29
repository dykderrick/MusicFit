//
//  PlaylistView.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/7/22.
//

import SwiftUI

struct PlaylistView: View {
    @ObservedObject var musicManager: AppleMusicManager
    @ObservedObject var musicPlayer: MusicPlayer
    @ObservedObject var miniPlayerIntentHandler: MiniPlayerIntentHandler
    
    let musicFitPlaylistManager: MusicFitPlaylistManager
    
    @State private var showingPlaylistCreationSheet = false
    
    init(
        _ musicManager: AppleMusicManager,
        _ musicPlayer: MusicPlayer,
        _ miniPlayerIntentHandler: MiniPlayerIntentHandler,
        _ musicFitPlaylistManager: MusicFitPlaylistManager
    ) {
        self.musicManager = musicManager
        self.musicPlayer = musicPlayer
        self.miniPlayerIntentHandler = miniPlayerIntentHandler
        self.musicFitPlaylistManager = musicFitPlaylistManager
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(MusicFitStatus.allCases, id:\.self) { status in
                        PlaylistItem(musicFitPlaylistManager, status: status)
                            .listRowBackground(Color.black)
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                }
                .navigationTitle("Playlist")
                
                MiniPlayer(musicPlayer, miniPlayerIntentHandler)
                Spacer()
            }
        }
        // Showing a playlist creation sheet if the user has empty playlists for MusicFit.
        .onAppear() {
            showingPlaylistCreationSheet = musicFitPlaylistManager.musicFitPlaylistsAreEmpty()
        }
        .sheet(isPresented: $showingPlaylistCreationSheet) {
            PlaylistCreationSheet(musicManager, musicFitPlaylistManager)
        }
        .sheet(isPresented: $miniPlayerIntentHandler.showingPlayerSheet) {
            PlayerSheet(musicPlayer)
        }
        
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        let musicManager = AppleMusicManager()
        let fileHandler = FileHandler()
        let miniPlayerIntentHandler = MiniPlayerIntentHandler()
        let musicFitPlaylistManager = MusicFitPlaylistManager(musicManager: musicManager, fileHandler: fileHandler)
        let musicPlayer = MusicPlayer(fileHandler: fileHandler, musicManager: musicManager)
        
        Group {
            PlaylistView(musicManager, musicPlayer, miniPlayerIntentHandler, musicFitPlaylistManager)
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
            
            PlaylistView(musicManager, musicPlayer, miniPlayerIntentHandler, musicFitPlaylistManager)
                .preferredColorScheme(.light)
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
        }
    }
}
