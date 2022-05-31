//
//  MiniPlayer.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/15/22.
//

import SwiftUI

struct MiniPlayer: View {
	@ObservedObject var musicPlayer: MusicPlayer
	
    var body: some View {
		HStack (spacing: 50) {
			Text(musicPlayer.currentPlayingSong.name)  // Song name
			Text(musicPlayer.currentPlayingSong.artistName)  // Artist Name
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
		.background(.white.opacity(0.1))
    }
}

struct MiniPlayer_Previews: PreviewProvider {
    static var previews: some View {
		let FileHandler = FileHandler()
		let musicManager = AppleMusicManager()
		let musicPlayer = MusicPlayer(fileHandler: FileHandler, musicManager: musicManager)
		
		MiniPlayer(musicPlayer: musicPlayer)
			.preferredColorScheme(.dark)
    }
}
