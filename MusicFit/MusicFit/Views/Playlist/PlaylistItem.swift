//
//  PlaylistItem.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/10/22.
//

import SwiftUI

struct PlaylistItem: View {
    var body: some View {
		HStack {
			Image(systemName: "play.fill")
				.resizable()
				.frame(width: 93.0, height: 93.0)
//				.cornerRadius(20)
//				.shadow(radius: 10)
			
			Spacer()
				.frame(width: 30.0, height: nil)
			
			VStack {
				Text("FITNESS")
					.font(.largeTitle)
					.foregroundColor(Color(hex: "45FFCC"))
					.bold()
					.frame(width: 150.0)
					
					
				HStack {
					Text("34")
						.foregroundColor(Color(hex: "848484"))
					Image(systemName: "heart.fill")
						.foregroundColor(Color(hex: "#25E495"))
					Spacer()
						.frame(width: 75.0)
				}
				.padding(.trailing)
				.frame(width: 150.0)
				
				HStack {
					Text("234")
						.foregroundColor(Color(hex: "848484"))
					Text(" Songs")
						.foregroundColor(Color(hex: "848484"))
					Spacer()
						.frame(width: 50.0)
				}
				.frame(width: 150.0)
			}
			.frame(height: 93.0)
			
			Spacer()
				.frame(width: 30.0)
		}
		.padding(.horizontal, 45.0)
		.frame(height: 112.0)
		.background(.white.opacity(0.1))
    }
}

struct PlaylistItem_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistItem()
			.preferredColorScheme(.dark)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
		
		PlaylistItem()
			.preferredColorScheme(.dark)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}
