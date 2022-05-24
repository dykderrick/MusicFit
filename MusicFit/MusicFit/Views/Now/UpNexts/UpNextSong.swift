//
//  UpNextSong.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/24/22.
//

import SwiftUI

struct UpNextSong: View {
    var body: some View {
		HStack(alignment: .center, spacing: 10) {
			Image(systemName: "figure.walk")
				.resizable()
				.frame(width: 54, height: 54)
			
			VStack(alignment: .leading, spacing: 10) {
				Text("Airwaves")
					.foregroundColor(.white)
					.font(.system(size: 13, weight: .regular))
				
				Text("will.i.am / Britney Spears")
					.foregroundColor(Color(hex: "#848484"))
					.font(.system(size: 11, weight: .regular))
				
				Text("04:45")
					.foregroundColor(Color(hex: "#848484"))
					.font(.system(size: 11, weight: .regular))
			}
			
			Spacer()
			
			Image(systemName: "heart.fill")
				.foregroundColor(Color(hex: "#25E495"))
		}
		.frame(width: UIScreen.main.bounds.width - 130, height: UIScreen.main.bounds.height / 10)
    }
}

struct UpNextSong_Previews: PreviewProvider {
    static var previews: some View {
        UpNextSong()
			.preferredColorScheme(.dark)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
		
		UpNextSong()
			.preferredColorScheme(.light)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}
