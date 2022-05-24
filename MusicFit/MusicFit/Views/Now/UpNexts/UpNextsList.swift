//
//  UpNextsList.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/24/22.
//

import SwiftUI

struct UpNextsList: View {
    var body: some View {
		List {
			HStack(alignment: .center, spacing: 50) {
				Text("Up Next Songs in Running")
					.foregroundColor(.white)
					.font(.system(size: 19, weight: .semibold))
				
				Button(action: {
					
				}) {
					Image(systemName: "ellipsis")
				}
				.tint(Color(hex: "#D8D8D8"))
			}
			
			UpNextSong()
			UpNextSong()
		}
    }
}

struct UpNextsList_Previews: PreviewProvider {
    static var previews: some View {
        UpNextsList()
			.preferredColorScheme(.dark)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
		
		UpNextsList()
			.preferredColorScheme(.light)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}
