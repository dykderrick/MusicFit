//
//  NowStatus.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/22/22.
//

import SwiftUI

struct NowStatus: View {
	@ObservedObject var workoutManager: WorkoutManager
	@ObservedObject var musicPlayer: MusicPlayer
	

	
    var body: some View {
		VStack(alignment: .leading, spacing: 40) {
			HStack(alignment: .center, spacing: 100) {
				// MARK: - MusicFit Predicted Current Status Area
				VStack(alignment: .leading, spacing: 5) {
					Text("Status:")
						.foregroundColor(Color(hex: "#D1D1D1"))
						.font(.system(size: 19, weight: .semibold))
					
					HStack {
						Text(workoutManager.predictedStatus.rawValue.uppercased())
							.foregroundColor(.white)
							.font(.system(size: 19, weight: .semibold))
						Image(systemName: workoutManager.predictedStatusImageSystemName ?? "xmark.octagon")
					}
				}
				
				// MARK: - Fitness Plan Navigation
				Text("Fitness Plan >")  // TODO: Add Fitness Plan page
					.underline()
			}
			
			// MARK: - Start Workout Button
			
			// TODO: Handle Button Disable Function
			
			// FIXME: Can we make the button action asynchronous?
			Button(action: {
				// When click this button, workout will be started,
				// and "Resting" playlist will be added to queue.
				
				// Handle workout start intent
				workoutManager.startWorkout()
				
				// Make the Player play
				musicPlayer.playerPlay()
			}) {
				Text("Start Workout")
					.font(.system(size: 20, weight: .semibold))
					.foregroundColor(Color.black)
					.frame(
						width: UIScreen.main.bounds.width - 120,
						height: UIScreen.main.bounds.height / 13
					)
					.background(Color(hex: "\(MusicFitColors.green)"))
					.clipShape(Capsule())
			}
			.frame(
				width: UIScreen.main.bounds.width - 120,
				height: UIScreen.main.bounds.height / 13
			)
		}
		.frame(
			width: UIScreen.main.bounds.width - 15,
			height: UIScreen.main.bounds.height / 5
		)
		.background(
			Image("NowStatusBackground")
				.resizable()
				.cornerRadius(20)
		)
		// MARK: -
    }
}

struct NowStatus_Previews: PreviewProvider {
    static var previews: some View {
		let musicManager = AppleMusicManager()
		let fileHandler = FileHandler()
		let musicPlayer = MusicPlayer(
			fileHandler: fileHandler,
			musicManager: musicManager,
			previewSong: PreviewStatics.previewSong
		)
		let workoutManager = WorkoutManager(musicPlayer: musicPlayer)
		
		NowStatus(workoutManager: workoutManager, musicPlayer: musicPlayer)
			.preferredColorScheme(.dark)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
		
		NowStatus(workoutManager: workoutManager, musicPlayer: musicPlayer)
			.preferredColorScheme(.light)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}
