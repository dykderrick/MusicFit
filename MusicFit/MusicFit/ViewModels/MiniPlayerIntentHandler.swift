//
//  MiniPlayerIntentHandler.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/31/22.
//

import Foundation

class MiniPlayerIntentHandler: ObservableObject {
	// MARK: - Published variables
	@Published var showingPlayerSheet = false
	
	// MARK: - Intent
	func showPlayerSheet() {
		self.showingPlayerSheet = true
	}
	
	func playPauseButtonClicked() {
		
	}
	
}
