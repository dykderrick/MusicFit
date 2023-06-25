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
    // MARK: - ObservedObject variables
    @ObservedObject var musicManager: AppleMusicManager
    @ObservedObject var workoutManager: WorkoutManager
    @ObservedObject var musicPlayer: MusicPlayer
    @ObservedObject var miniPlayerIntentHandler: MiniPlayerIntentHandler
    
    let fileHandler: FileHandler
    let intentHandler: ContentViewIntentHandler
    let musicFitPlaylistManager: MusicFitPlaylistManager
    @State private var selection = 0
    
    init(
        _ musicManager: AppleMusicManager,
        _ workoutManager: WorkoutManager,
        _ musicPlayer: MusicPlayer,
        _ miniPlayerIntentHandler: MiniPlayerIntentHandler,
        _ fileHandler: FileHandler,
        _ intentHandler: ContentViewIntentHandler,
        _ musicFitPlaylistManager: MusicFitPlaylistManager
    ) {
        self.musicManager = musicManager
        self.workoutManager = workoutManager
        self.musicPlayer = musicPlayer
        self.miniPlayerIntentHandler = miniPlayerIntentHandler
        self.fileHandler = fileHandler
        self.intentHandler = intentHandler
        self.musicFitPlaylistManager = musicFitPlaylistManager
    }
    
    var body: some View {
        TabView(selection: $selection) {
            NowView(
                workoutManager: workoutManager,
                musicPlayer: musicPlayer,
                miniPlayerIntentHandler: miniPlayerIntentHandler
            )
            .tag(0)
            .tabItem {
                VStack {
                    Image(systemName: "music.note")
                    Text("Now")
                }
            }
            
            PlaylistView(
                musicManager: musicManager,
                musicPlayer: musicPlayer,
                miniPlayerIntentHandler: miniPlayerIntentHandler,
                musicFitPlaylistManager: musicFitPlaylistManager
            )
            .tag(1)
            .tabItem {
                VStack {
                    Image(systemName: "text.append")
                    Text("Playlist")
                }
            }
            
            SearchView()
                .tag(2)
                .tabItem {
                    VStack {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                }
            
            MeView()
                .tag(3)
                .tabItem {
                    VStack {
                        Image(systemName: "person.fill")
                        Text("Me")
                    }
                }
        }
        .accentColor(Color(hex: "\(MusicFitColors.green)"))
        .onAppear() {
            // Copy Bundle file MusicFitPlaylists.json to App Documents directory.
            intentHandler.setMusicFitPlaylistMetadata(fileHandler)
            
            // Make sure all playlists previously set are available. If not available, set to "".
            intentHandler.setMusicFitPlaylistsAvailability(musicManager)
            
            SKCloudServiceController.requestAuthorization { (status) in
                if status == .authorized {
                    musicManager.getUserToken { userToken in
                        print(userToken)
                        
                        /*
                         musicManager.createPlaylistWithCatelogSongs(userToken, playlistName: "test playlist", playlistDescription: "test description", playlistFolderId: "p.playlistsroot", songCatelogIds: ["1450695739", "1440811598"]) { playlist in
                         print(playlist)
                         }
                         */
                        
                        /*
                         musicManager.getSongRating(userToken, id: "1544494722") { rating in
                         print(rating)
                         }
                         */
                        
                        /*
                         musicManager.createLibraryPlaylistFolder(userToken, folderName: "test folder") { isCreated, folderId in
                         print(isCreated)
                         print(folderId)
                         }
                         */
                        
                        print("RESTING TEST: \(musicFitPlaylistManager.getMusicFitPlaylistId(ofStatus: .Resting))")
                        
                        
                        musicManager.getAllLibraryPlaylists(userToken) { playlists in
                            print(playlists)
                        }
                        
                        /*
                         musicManager.fetchStorefrontID(userToken: userToken) { storefrontID in
                         print(storefrontID)
                         musicManager.searchAppleMusic(userToken, storefrontID, "Taylor Swift") { songs in
                         print(songs)
                         }
                         }
                         */
                    }
                }
            }
        }
        // When music player now playing item changes (probably changes to another song),
        // update the currentPlayingSong and upNextSongsQueue, the two observed variables in MusicPlayer.
        .onReceive(NotificationCenter.default.publisher(
            for: .MPMusicPlayerControllerNowPlayingItemDidChange)
        ) { _ in
            musicPlayer.updateCurrentPlayingSong()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let musicManager = AppleMusicManager()
        let fileHandler = FileHandler()
        let musicFitPlaylistManager = MusicFitPlaylistManager(
            musicManager: musicManager,
            fileHandler: fileHandler
        )
        let contentViewIntentHandler = ContentViewIntentHandler(
            musicFitPlaylistManager: musicFitPlaylistManager
        )
        let miniPlayerIntentHandler = MiniPlayerIntentHandler()
        let musicPlayer = MusicPlayer(
            fileHandler: fileHandler,
            musicManager: musicManager,
            previewSong: PreviewStatics.previewSong
        )
        let workoutManager = WorkoutManager(musicPlayer: musicPlayer)
        
        
        Group {
            ContentView(
                musicManager,
                workoutManager,
                musicPlayer,
                miniPlayerIntentHandler,
                fileHandler,
                contentViewIntentHandler,
                musicFitPlaylistManager
            )
            .preferredColorScheme(.dark)
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
            
            ContentView(
                musicManager,
                workoutManager,
                musicPlayer,
                miniPlayerIntentHandler,
                fileHandler,
                contentViewIntentHandler,
                musicFitPlaylistManager
            )
            .preferredColorScheme(.light)
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
        }
    }
}
