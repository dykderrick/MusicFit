//
//  NowView.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/7/22.
//

import SwiftUI

struct NowView: View {
    @ObservedObject var workoutManager: WorkoutManager
    @ObservedObject var musicPlayer: MusicPlayer
    @ObservedObject var miniPlayerIntentHandler: MiniPlayerIntentHandler
    
    init(
        _ workoutManager: WorkoutManager,
        _ musicPlayer: MusicPlayer,
        _ miniPlayerIntentHandler: MiniPlayerIntentHandler
    ) {
        self.workoutManager = workoutManager
        self.musicPlayer = musicPlayer
        self.miniPlayerIntentHandler = miniPlayerIntentHandler
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Let's MusicFit!")
                    .foregroundColor(.white)
                    .font(.system(size: 34, weight: .semibold))
                
                Spacer(minLength: 80)
            }
            
            NowStatus(workoutManager, musicPlayer)
            
            UpNextsList(musicPlayer, workoutManager)
            
            MiniPlayer(musicPlayer, miniPlayerIntentHandler)
        }
        .padding()
        .sheet(isPresented: $miniPlayerIntentHandler.showingPlayerSheet) {
            PlayerSheet(musicPlayer)
        }
    }
}

struct NowView_Previews: PreviewProvider {
    static var previews: some View {
        let fileHandler = FileHandler()
        let musicManager = AppleMusicManager()
        let miniPlayerIntentHandler = MiniPlayerIntentHandler()
        let musicPlayer = MusicPlayer(
            fileHandler: fileHandler,
            musicManager: musicManager,
            previewSong: PreviewStatics.previewSong
        )
        let workoutManager = WorkoutManager(musicPlayer: musicPlayer)
        
        Group {
            NowView(workoutManager, musicPlayer, miniPlayerIntentHandler)
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
            
            NowView(workoutManager, musicPlayer, miniPlayerIntentHandler)
                .preferredColorScheme(.light)
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
        }
        
        
    }
}
