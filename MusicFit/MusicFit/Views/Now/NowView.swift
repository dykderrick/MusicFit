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
	
    var body: some View {
		VStack {
			HStack {
				Text("Let's MusicFit!")
					.foregroundColor(.white)
					.font(.system(size: 34, weight: .semibold))

				Spacer(minLength: 80)
			}
			
			NowStatus(workoutManager: workoutManager)
			
			UpNextsList(musicPlayer: musicPlayer)
			
			MiniPlayer(musicPlayer: musicPlayer)
		}
		.padding()
    }
}

struct NowView_Previews: PreviewProvider {
    static var previews: some View {
		let workoutManager = WorkoutManager()
		let fileHandler = FileHandler()
		let musicManager = AppleMusicManager()
		let musicPlayer = MusicPlayer(fileHandler: fileHandler, musicManager: musicManager)
		
		NowView(workoutManager: workoutManager, musicPlayer: musicPlayer)
			.preferredColorScheme(.dark)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
		
		NowView(workoutManager: workoutManager, musicPlayer: musicPlayer)
			.preferredColorScheme(.light)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}
