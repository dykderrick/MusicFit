//
//  UpNextSong.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/24/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct UpNextSong: View {
	var song: Song
	
    var body: some View {
		HStack(alignment: .center, spacing: 10) {
			WebImage(
				url: URL(
					string: song.artworkURL
						.replacingOccurrences(of: "{w}", with: "60")
						.replacingOccurrences(of: "{h}", with: "60")
				)
			)
			.resizable()
			.frame(width: 60, height: 60)
			.cornerRadius(20)
			
			VStack(alignment: .leading, spacing: 10) {
				Text(song.name)
					.foregroundColor(.white)
					.font(.system(size: 13, weight: .regular))
				
				Text(song.artistName)
					.foregroundColor(Color(hex: "#848484"))
					.font(.system(size: 11, weight: .regular))
				
				// FIXME: Song Duration isn't Correct
				Text("\(String(Int(song.durationInMillis / 60000))):\(String(Int(song.durationInMillis / 60000 % 1 * 60)))")  // TODO: Way too ugly here.
					.foregroundColor(Color(hex: "#848484"))
					.font(.system(size: 11, weight: .regular))
			}
			
			Spacer()
			
			Image(systemName: "heart.fill")  // TODO: Add button to like/dislike the song
				.foregroundColor(Color(hex: "#25E495"))
		}
		.frame(width: UIScreen.main.bounds.width - 130, height: UIScreen.main.bounds.height / 10)
    }
}

struct UpNextSong_Previews: PreviewProvider {
    static var previews: some View {
		let song = Song(id: "", name: "Unknown", artistName: "Unknown Artist", artworkURL: "", genreNames: [""], durationInMillis: 194088)
		
		UpNextSong(song: song)
			.preferredColorScheme(.dark)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
		
		UpNextSong(song: song)
			.preferredColorScheme(.light)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}
