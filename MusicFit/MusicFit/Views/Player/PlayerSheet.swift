//
//  PlayerSheet.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/31/22.
//

import SwiftUI
import MediaPlayer
import SDWebImageSwiftUI

struct PlayerSheet: View {
	@ObservedObject var musicPlayer: MusicPlayer
	
	@State var pauseResumeButtonImageSystemName = "play.fill"
	@State var progressAmount = 0.0
	
	let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
	
    var body: some View {
		VStack {
			// MARK: - Song Artwork Image
			WebImage(
				url: URL(
					string: musicPlayer.currentPlayingSong.artworkURL
						.replacingOccurrences(of: "{w}", with: "350")
						.replacingOccurrences(of: "{h}", with: "350")
				)
			)
			.resizable()
			.frame(width: 350, height: 350)
			.cornerRadius(20)
			.shadow(radius: 10)
			.padding()
			
			// MARK: - Song name and artist
			VStack(alignment: .leading, spacing: 5) {
				Text(musicPlayer.currentPlayingSong.name)
					.font(.system(size: 23, weight: .semibold))
					.frame(width: 300, height: 30, alignment: .leading)
					
				Text(musicPlayer.currentPlayingSong.artistName)
					.font(.system(size: 16, weight: .regular))
					.frame(width: 300, height: 30, alignment: .leading)
			}
			
			// MARK: - Progress Bar
			ProgressView(
				value: progressAmount,
				total: Double(musicPlayer.currentPlayingSong.durationInMillis)
			)
				.frame(width: UIScreen.main.bounds.width - 50, height: 30)
				.tint(Color(hex: "\(MusicFitColors.green)"))
				.onReceive(timer) { _ in
					progressAmount = musicPlayer.player.currentPlaybackTime * 1000
				}
			
			// MARK: - Song Playback Time
			HStack(alignment: .center, spacing: UIScreen.main.bounds.width - 140) {
				Text(MusicPlayerConstants().timeIntervalFormatter.string(
					from: TimeInterval(progressAmount / 1000)) ?? "00:00"
				)
				Text(MusicPlayerConstants().timeIntervalFormatter.string(
					from: TimeInterval(self.musicPlayer.currentPlayingSong.durationInMillis / 1000)) ?? "00:00"
				)
			}
			
			HStack(alignment: .center, spacing: 35) {
				// MARK: - Like / Dislike Button
				Button(action: {
					// TODO: Add Like/Dislike Button functions
				}, label: {
					Image(systemName: "heart.fill")  // TODO: Change it
						.tint(Color(hex: "\(MusicFitColors.green)"))
				})
				
				// MARK: - Revert to beginning / Last Song Button
				Button(action: {
					// TODO: Add backward functions
				}, label: {
					Image(systemName: "backward.fill")
						.tint(.white)
				})
				
				// MARK: - Pause / Play Button
				Button(action: {
					if MPMusicPlayerController.applicationQueuePlayer.playbackState == .playing {
						musicPlayer.playerPause()
					} else {
						musicPlayer.playerPlay()
					}
				}, label: {
					ZStack {
						Circle()
							.frame(width: 80, height: 80)
							.tint(Color(hex: "\(MusicFitColors.green)"))
							.shadow(radius: 10)
						
						Image(systemName: MPMusicPlayerController.applicationQueuePlayer.playbackState == .playing ? "pause.fill" : "play.fill")
							.foregroundColor(.white)
							.font(.system(.title))
							.onReceive(NotificationCenter.default.publisher(for: .MPMusicPlayerControllerPlaybackStateDidChange)) { _ in
								// FIXME: This is a bug right now. The button cannot be updated. You know the reason.
								if MPMusicPlayerController.applicationQueuePlayer.playbackState == .playing {
									pauseResumeButtonImageSystemName = "pause.fill"
								} else {
									pauseResumeButtonImageSystemName = "play.fill"
								}
							}
					}
				})
				
				// MARK: - Skip to Next Song Button
				Button(action: {
					// TODO: Add action
				}, label: {
					Image(systemName: "forward.fill")
						.tint(.white)
				})
				
				// MARK: - More Functions Button
				Button(action: {
					// TODO: Add action
				}, label: {
					Image(systemName: "ellipsis")
						.tint(Color(hex: "\(MusicFitColors.gray)"))
				})
				
			}
			
			
			
			
		}
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
		let musicPlayer = MusicPlayer(
			fileHandler: FileHandler(),
			musicManager: AppleMusicManager(),
			previewSong: PreviewStatics.previewSong
		)
		
		PlayerSheet(musicPlayer: musicPlayer)
			.preferredColorScheme(.dark)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
		
		PlayerSheet(musicPlayer: musicPlayer)
			.preferredColorScheme(.light)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}
