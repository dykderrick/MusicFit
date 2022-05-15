//
//  MiniPlayer.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/15/22.
//

import SwiftUI

struct MiniPlayer: View {
    var body: some View {
		HStack (spacing: 50) {
			Text("Not Playling")
			Text("Unknown Artist")
			Button(action: {
				
			}) {
				Image(systemName: "play.fill")
					.foregroundColor(Color(hex: "D8D8D8"))
			}
			Button(action: {
				
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
        MiniPlayer()
			.preferredColorScheme(.dark)
    }
}
