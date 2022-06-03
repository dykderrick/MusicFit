//
//  WorkoutManager.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/30/22.
//

import Foundation
import CoreMotion
import CoreML

struct WorkoutManagerConstants {
	static let statusImageSystemNames: [MusicFitStatus: String] = [
		.Resting: "figure.stand",
		.Walking: "figure.walk",
		.Running: "hare.fill"
	]
}

class WorkoutManager: ObservableObject {
	// MARK: - Variable Initiaions
	@Published var predictedStatus = MusicFitStatus.Resting
	@Published var predictedStatusImageSystemName = WorkoutManagerConstants.statusImageSystemNames[MusicFitStatus.Resting]
	@Published var workoutStarted = false
	
	
	let musicPlayer: MusicPlayer
	let motionManager: CMMotionManager  // To handle accelerometers
	let activityClassifier: ActivityClassifier
	
	var currentIndexInPredictionWindow = 0
	let accelDataX = try! MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
	let accelDataY = try! MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
	let accelDataZ = try! MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
	var stateOutput = try! MLMultiArray(shape:[ModelConstants.stateInLength as NSNumber], dataType: MLMultiArrayDataType.double)
	
	// MARK: - Initiators
	init(musicPlayer: MusicPlayer) {
		self.musicPlayer = musicPlayer
		self.motionManager = CMMotionManager()
		self.activityClassifier = ActivityClassifier()  // TODO: Handle warnings here.
	}
	
	// MARK: - Functions
	func addAccelSampleToDataArray (accelSample: CMAccelerometerData) {
		// Add the current accelerometer reading to the data array
		accelDataX[[currentIndexInPredictionWindow] as [NSNumber]] = accelSample.acceleration.x as NSNumber
		accelDataY[[currentIndexInPredictionWindow] as [NSNumber]] = accelSample.acceleration.y as NSNumber
		accelDataZ[[currentIndexInPredictionWindow] as [NSNumber]] = accelSample.acceleration.z as NSNumber

		// Update the index in the prediction window data array
		currentIndexInPredictionWindow += 1

		// If the data array is full, call the prediction method to get a new model prediction.
		// We assume here for simplicity that the Gyro data was added to the data arrays as well.
		if (currentIndexInPredictionWindow == ModelConstants.predictionWindowSize) {
			if let predictedActivity = performModelPrediction() {

				// Use the predicted activity here
				switch predictedActivity {
				case "Resting":
					if self.predictedStatus != .Resting {
						self.musicPlayer.modifyUpNextSongsQueueByStatus(.Resting)
					}
					self.predictedStatus = .Resting
				case "Running":
					if self.predictedStatus != .Running {
						self.musicPlayer.modifyUpNextSongsQueueByStatus(.Running)
					}
					self.predictedStatus = .Running
				case "Walking":
					if self.predictedStatus != .Walking {
						self.musicPlayer.modifyUpNextSongsQueueByStatus(.Walking)
					}
					self.predictedStatus = .Walking
				default:
					print("Not Predictable")
				}
				
				// Set predicted status image system name
				self.predictedStatusImageSystemName = WorkoutManagerConstants.statusImageSystemNames[self.predictedStatus]

				// Start a new prediction window
				currentIndexInPredictionWindow = 0
			}
		}
	}
	
	func performModelPrediction () -> String? {
		// Perform model prediction
		let modelPrediction = try! activityClassifier.prediction(accelerometerAccelerationX_G_: accelDataX, accelerometerAccelerationY_G_: accelDataY, accelerometerAccelerationZ_G_: accelDataZ, stateIn: stateOutput)

		// Update the state vector
		stateOutput = modelPrediction.stateOut

		// Return the predicted activity - the activity with the highest probability
		return modelPrediction.label
	}
	
	
	func prepareAccelerometer() {
		// Deal with accelerometer data
		if motionManager.isAccelerometerAvailable {
			motionManager.accelerometerUpdateInterval = TimeInterval(ModelConstants.sensorsUpdateInterval)

			motionManager.startAccelerometerUpdates(to: .main) { accelerometerData, error in
				guard let accelerometerData = accelerometerData else { return }
				
				// Add data to published
//				self.xAcc = accelerometerData.acceleration.x
//				self.yAcc = accelerometerData.acceleration.y
//				self.zAcc = accelerometerData.acceleration.z

				// Add the current data sample to the data array
				self.addAccelSampleToDataArray(accelSample: accelerometerData)
			}
		} else {
			// Handle Accelerometer Not Available
		}
	}
	
	func stopAccelerometer() {
		motionManager.stopAccelerometerUpdates()
	}
	
	
	// MARK: - Intent
	func startWorkout() {
		print("Workout has been started!")
		
		workoutStarted = true
		
		prepareAccelerometer()
		
		
	}
	
	func endWorkout() {
		print("Workout Has Been Stopped!")
		
		workoutStarted = false
		
		stopAccelerometer()
	}
}
