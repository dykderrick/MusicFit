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
	
    var body: some View {
		VStack {
			HStack {
				Text("Let's MusicFit!")
					.foregroundColor(.white)
					.font(.system(size: 34, weight: .semibold))

				Spacer(minLength: 80)
			}
			
			NowStatus(workoutManager: workoutManager, musicPlayer: musicPlayer)
			
			UpNextsList(musicPlayer: musicPlayer, workoutManager: workoutManager)
			
			MiniPlayer(musicPlayer: musicPlayer, miniPlayerIntentHandler: miniPlayerIntentHandler)
		}
		.padding()
		.sheet(isPresented: $miniPlayerIntentHandler.showingPlayerSheet) {
			PlayerSheet(musicPlayer: musicPlayer)
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
		
		NowView(workoutManager: workoutManager, musicPlayer: musicPlayer, miniPlayerIntentHandler: miniPlayerIntentHandler)
			.preferredColorScheme(.dark)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
		
		NowView(workoutManager: workoutManager, musicPlayer: musicPlayer, miniPlayerIntentHandler: miniPlayerIntentHandler)
			.preferredColorScheme(.light)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}
