//
//  PlaylistView.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/7/22.
//

import SwiftUI

struct PlaylistView: View {
	@State private var playlistCount = [0, 1, 2, 3]
	
    var body: some View {
		NavigationView {
			VStack {
				List {
					ForEach(playlistCount, id:\.self) { num in
						PlaylistItem()
							.listRowBackground(Color.black)
					}
					.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
				}
				.navigationTitle("Playlist")
				
				MiniPlayer()
				Spacer()
			}
		}
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView()
			.preferredColorScheme(.dark)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
		
		PlaylistView()
			.preferredColorScheme(.dark)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}
