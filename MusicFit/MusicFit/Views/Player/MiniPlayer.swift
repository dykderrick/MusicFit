//
//  MiniPlayer.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/15/22.
//

import SwiftUI

struct MiniPlayer: View {
	@ObservedObject var musicPlayer: MusicPlayer
	@ObservedObject var miniPlayerIntentHandler: MiniPlayerIntentHandler
	
    var body: some View {
		HStack (spacing: 50) {
			Button(action: {
				miniPlayerIntentHandler.showPlayerSheet()
			}, label: {
				HStack(alignment: .bottom, spacing: 40) {
					Text(musicPlayer.currentPlayingSong.name)  // Song name
						.font(.system(size: 20, weight: .medium))
						.tint(.white)
					Text(musicPlayer.currentPlayingSong.artistName)  // Artist Name
						.font(.system(size: 15, weight: .regular))
						.tint(Color(hex: "\(MusicFitColors.gray)"))
				}
				.frame(height: 54)
			})
			

			
			Button(action: {  // Pause / Resume Button
				
			}) {
				Image(systemName: "play.fill")
					.foregroundColor(Color(hex: "\(MusicFitColors.gray)"))
			}
			Button(action: {  // Next Song Button
				
			}) {
				Image(systemName: "forward.fill")
					.foregroundColor(Color(hex: "#7B7B7B"))
			}
		}
		.frame(height: 54.0)
		.frame(minWidth: 300, maxWidth: .infinity)
//		.background(Color(hex: "\(MusicFitColors.gray)"))
    }
}

struct MiniPlayer_Previews: PreviewProvider {
    static var previews: some View {
		let FileHandler = FileHandler()
		let musicManager = AppleMusicManager()
		let miniPlayerIntentHandler = MiniPlayerIntentHandler()
		let musicPlayer = MusicPlayer(fileHandler: FileHandler, musicManager: musicManager, previewSong: PreviewStatics.previewSong)
		
		MiniPlayer(musicPlayer: musicPlayer, miniPlayerIntentHandler: miniPlayerIntentHandler)
			.preferredColorScheme(.dark)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
		
		MiniPlayer(musicPlayer: musicPlayer, miniPlayerIntentHandler: miniPlayerIntentHandler)
			.preferredColorScheme(.light)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}
