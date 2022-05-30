//
//  NowStatus.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/22/22.
//

import SwiftUI

struct NowStatus: View {
	@ObservedObject var workoutManager: WorkoutManager
	
    var body: some View {
		VStack(alignment: .leading, spacing: 40) {
			HStack(alignment: .center, spacing: 100) {
				VStack(alignment: .leading, spacing: 5) {
					Text("Status:")
						.foregroundColor(Color(hex: "#D1D1D1"))
						.font(.system(size: 19, weight: .semibold))
					
					HStack {
						Text(workoutManager.predictedStatus.rawValue.uppercased())
							.foregroundColor(.white)
							.font(.system(size: 19, weight: .semibold))
						Image(systemName: "figure.walk")
					}
				}
				
				Text("Fitness Plan >")
					.underline()
			}
			
			// TODO: Handle Button Disable Function
			Button(action: {
				// Handle workout start intent
				workoutManager.startWorkout()
			}) {
				Text("Start Workout")
					.font(.system(size: 20, weight: .semibold))
					.foregroundColor(Color.black)
					.frame(width: UIScreen.main.bounds.width - 120, height: UIScreen.main.bounds.height / 13)
					.background(Color(hex: "#25E495"))
					.clipShape(Capsule())
			}
			.frame(width: UIScreen.main.bounds.width - 120, height: UIScreen.main.bounds.height / 13)
		}
		.frame(width: UIScreen.main.bounds.width - 15, height: UIScreen.main.bounds.height / 5)
		.background(
			Image("NowStatusBackground")
				.resizable()
				.cornerRadius(20)
		)
    }
}

struct NowStatus_Previews: PreviewProvider {
    static var previews: some View {
		let workoutManager = WorkoutManager()
		
		NowStatus(workoutManager: workoutManager)
			.preferredColorScheme(.dark)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
		
		NowStatus(workoutManager: workoutManager)
			.preferredColorScheme(.light)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}
