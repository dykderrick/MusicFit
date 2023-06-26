//
//  UpNextsList.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/24/22.
//

import SwiftUI

struct UpNextsList: View {
    @ObservedObject var musicPlayer: MusicPlayer
    @ObservedObject var workoutManager: WorkoutManager
    
    @State var songsQueue: [Song] = []
    
    init(
        _ musicPlayer: MusicPlayer,
        _ workoutManager: WorkoutManager
    ) {
        self.musicPlayer = musicPlayer
        self.workoutManager = workoutManager
        self.songsQueue = songsQueue
    }
    
    var body: some View {
        List {
            HStack(alignment: .center, spacing: 50) {
                Text("Up Next Songs in \(workoutManager.predictedStatus.rawValue)")
                    .foregroundColor(.white)
                    .font(.system(size: 19, weight: .semibold))
                
                Button(action: {
                    
                }) {
                    Image(systemName: "ellipsis")
                }
                .tint(Color.musicFitGray)
            }
            
            ForEach(musicPlayer.upNextSongsQueue[musicPlayer.player.indexOfNowPlayingItem ... musicPlayer.upNextSongsQueue.count - 1]) { song in
                if song.id != "myID" {  // Avoid showing empty song
                    UpNextSong(song: song)
                }
            }
        }
        .onAppear() {
            print(musicPlayer.upNextSongsQueue.count)
        }
    }
}

struct UpNextsList_Previews: PreviewProvider {
    static var previews: some View {
        let fileHandler = FileHandler()
        let musicManager = AppleMusicManager()
        let musicPlayer = MusicPlayer(fileHandler: fileHandler, musicManager: musicManager)
        let workoutManager = WorkoutManager(musicPlayer: musicPlayer)
        
        Group {
            UpNextsList(musicPlayer, workoutManager)
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
            
            UpNextsList(musicPlayer, workoutManager)
                .preferredColorScheme(.light)
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
        }
        
        
    }
}
