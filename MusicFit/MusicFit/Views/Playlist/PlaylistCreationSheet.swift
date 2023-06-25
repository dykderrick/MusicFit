//
//  PlaylistCreationSheet.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/17/22.
//

import SwiftUI

struct PlaylistCreationSheet: View {
    @ObservedObject var musicManager: AppleMusicManager
    let musicFitPlaylistManager: MusicFitPlaylistManager
    
    @State var textContent = "You Haven't Assigned MusicFit Playlists Yet."
    
    init(
        _ musicManager: AppleMusicManager,
        _ musicFitPlaylistManager: MusicFitPlaylistManager
    ) {
        self.musicManager = musicManager
        self.musicFitPlaylistManager = musicFitPlaylistManager
    }
    
    var body: some View {
        VStack {
            Text(textContent)
                .font(.title2)
            Spacer()
            Button(action: {
                musicFitPlaylistManager.initMusicFitPlaylists { isInitiated in
                    // TODO: Handle init result
                    textContent = "Thanks. You can now close this sheet."
                    print("Init result: \(isInitiated)")
                }
            }) {
                Text("Add MusicFit Playlist")
            }
        }
        .padding(.vertical, 300.0)
    }
}

struct PlaylistCreationSheet_Previews: PreviewProvider {
    static var previews: some View {
        let musicManager = AppleMusicManager()
        let fileHandler = FileHandler()
        let musicFitPlaylistManager = MusicFitPlaylistManager(musicManager: musicManager, fileHandler: fileHandler)
        
        Group {
            PlaylistCreationSheet(musicManager, musicFitPlaylistManager)
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
            
            PlaylistCreationSheet(musicManager, musicFitPlaylistManager)
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
        }
    }
}
