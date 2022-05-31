//
//  PlayerSheet.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/31/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct PlayerSheet: View {
	@ObservedObject var musicPlayer: MusicPlayer
	
    var body: some View {
		VStack {
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
			
			VStack(alignment: .leading, spacing: 5) {
				Text(musicPlayer.currentPlayingSong.name)
					.font(.system(size: 23, weight: .semibold))
					.frame(width: 300, height: 30, alignment: .leading)
					
				Text(musicPlayer.currentPlayingSong.artistName)
					.font(.system(size: 16, weight: .regular))
					.frame(width: 300, height: 30, alignment: .leading)
			}
			
			ProgressView(value: 50, total: 100)
				.frame(width: UIScreen.main.bounds.width - 50, height: 30)
				.tint(Color(hex: "\(MusicFitColors.green)"))
			
			HStack(alignment: .center, spacing: UIScreen.main.bounds.width - 140) {
				Text("01:24")
				Text("04:23")
			}
			
			
			HStack(alignment: .center, spacing: 35) {
				Button(action: {
					// TODO: Add Like/Dislike Button functions
				}, label: {
					Image(systemName: "heart.fill")
						.tint(Color(hex: "\(MusicFitColors.green)"))
				})
				
				Button(action: {
					// TODO: Add backward functions
				}, label: {
					Image(systemName: "backward.fill")
						.tint(.white)
				})
				
				Button(action: {
					// TODO: Add pause/play button action
				}, label: {
					ZStack {
						Circle()
							.frame(width: 80, height: 80)
							.tint(Color(hex: "\(MusicFitColors.green)"))
							.shadow(radius: 10)
						
						Image(systemName: "pause.fill")
							.foregroundColor(.white)
							.font(.system(.title))
					}
				})
				
				Button(action: {
					// TODO: Add forward functions
				}, label: {
					Image(systemName: "forward.fill")
						.tint(.white)
				})
				
				Button(action: {
					// TODO: Add more functions
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
