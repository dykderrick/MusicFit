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
                Text(MusicPlayerConstants().timeIntervalFormatter.string(
                    from: TimeInterval(self.song.durationInMillis / 1000)) ?? "00:00")
                .foregroundColor(Color(hex: "#848484"))
                .font(.system(size: 11, weight: .regular))
            }
            
            Spacer()
            
            Image(systemName: "heart.fill")  // TODO: Add button to like/dislike the song
                .foregroundColor(Color(hex: "\(MusicFitColors.green)"))
        }
        .frame(width: UIScreen.main.bounds.width - 130, height: UIScreen.main.bounds.height / 10)
    }
}

struct UpNextSong_Previews: PreviewProvider {
    static var previews: some View {
        let song = PreviewStatics.previewSong
        
        Group {
            UpNextSong(song: song)
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
            
            UpNextSong(song: song)
                .preferredColorScheme(.light)
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
        }
        
        
    }
}
