//
//  MiniPlayer.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/15/22.
//

import SwiftUI
import MediaPlayer

struct MiniPlayer: View {
	@ObservedObject var musicPlayer: MusicPlayer
	@ObservedObject var miniPlayerIntentHandler: MiniPlayerIntentHandler
	
	@State var pauseResumeButtonImageSystemName = "play.fill"
	
    var body: some View {
		HStack (spacing: 50) {
			// MARK: - Open Player Sheet Button
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
			

			// MARK: - Pause / Resume Button
			Button(action: {
				if MPMusicPlayerController.applicationQueuePlayer.playbackState == .playing {
					musicPlayer.playerPause()
				} else {
					musicPlayer.playerPlay()
				}
			}) {
				Image(systemName: pauseResumeButtonImageSystemName)
					.foregroundColor(Color(hex: "\(MusicFitColors.gray)"))
					.onReceive(NotificationCenter.default.publisher(for: .MPMusicPlayerControllerPlaybackStateDidChange)) { _ in
						if MPMusicPlayerController.applicationQueuePlayer.playbackState == .playing {
							pauseResumeButtonImageSystemName = "pause.fill"
						} else {
							pauseResumeButtonImageSystemName = "play.fill"
						}
					}
			}
			
			// MARK: - Skip to Next Song Button
			Button(action: {
				// TODO: Add logic here
				musicPlayer.playerSkipToNextItem()
			}) {
				Image(systemName: "forward.fill")
					.foregroundColor(Color(hex: "#7B7B7B"))
			}
			
			// MARK: -
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
