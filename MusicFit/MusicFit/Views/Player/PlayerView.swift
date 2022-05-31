//
//  PlayerView.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/31/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct PlayerView: View {
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
				Text("Bad Guy")
					.font(.system(size: 23, weight: .semibold))
					.frame(width: 300, height: 30, alignment: .leading)
					
				Text("Billie Eillish")
					.font(.system(size: 16, weight: .regular))
					.frame(width: 300, height: 30, alignment: .leading)
			}
			
			Text("PLEASE INSERT A PROGRESS BAR HERE")
			
			
			
			
			
			
			
		}
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
		let musicPlayer = MusicPlayer(
			fileHandler: FileHandler(),
			musicManager: AppleMusicManager(),
			previewSong: Song(
				id: "1450695739",
				name: "bad guy",
				artistName: "Billie Eillish",
				artworkURL: "https://is3-ssl.mzstatic.com/image/thumb/Music115/v4/1a/37/d1/1a37d1b1-8508-54f2-f541-bf4e437dda76/19UMGIM05028.rgb.jpg/{w}x{h}bb.jpg",
				genreNames: [""],
				durationInMillis: 194088
			)
		)
		
		PlayerView(musicPlayer: musicPlayer)
			.preferredColorScheme(.dark)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
		
		PlayerView(musicPlayer: musicPlayer)
			.preferredColorScheme(.light)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}