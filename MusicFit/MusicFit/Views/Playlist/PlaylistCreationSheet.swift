//
//  PlaylistCreationSheet.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/17/22.
//

import SwiftUI

struct PlaylistCreationSheet: View {
	@ObservedObject var musicManager: AppleMusicManager
	@State var textContent = "You Haven't Assigned MusicFit Playlist Yet."
	
    var body: some View {
		VStack {
			Text(textContent)
				.font(.title2)
			Spacer()
			Button(action: {
				musicManager.initMusicFitPlaylists { isInitiated in
					// TODO: Handle init result
					textContent = "Thanks. You can now close this sheet."
					print("Init result: \(isInitiated)")
				}
			}) {
				Text("Add MusicFit Playlist")
			}
		}
		.padding(.vertical, 300.0)
    }
}

struct PlaylistCreationSheet_Previews: PreviewProvider {
    static var previews: some View {
		let musicManager = AppleMusicManager()
		
        PlaylistCreationSheet(musicManager: musicManager)
			.preferredColorScheme(.dark)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
		
		PlaylistCreationSheet(musicManager: musicManager)
			.preferredColorScheme(.dark)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}
