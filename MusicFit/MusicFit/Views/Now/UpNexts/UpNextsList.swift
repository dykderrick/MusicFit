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
				.tint(Color(hex: "\(MusicFitColors.gray)"))
			}
			
			ForEach(musicPlayer.upNextSongsQueue) { song in
				UpNextSong(song: song)
			}
		}
    }
}

struct UpNextsList_Previews: PreviewProvider {
    static var previews: some View {
		let fileHandler = FileHandler()
		let musicManager = AppleMusicManager()
		let musicPlayer = MusicPlayer(fileHandler: fileHandler, musicManager: musicManager)
		let workoutManager = WorkoutManager(musicPlayer: musicPlayer)
		
		UpNextsList(musicPlayer: musicPlayer, workoutManager: workoutManager)
			.preferredColorScheme(.dark)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
		
		UpNextsList(musicPlayer: musicPlayer, workoutManager: workoutManager)
			.preferredColorScheme(.light)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}
