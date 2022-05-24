//
//  NowView.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/7/22.
//

import SwiftUI

struct NowView: View {
    var body: some View {
		VStack {
			HStack {
				Text("Let's MusicFit!")
					.foregroundColor(.white)
					.font(.system(size: 34, weight: .semibold))

				Spacer(minLength: 80)
			}
			
			NowStatus()
			
			UpNextsList()
			
			MiniPlayer()
		}
    }
}

struct NowView_Previews: PreviewProvider {
    static var previews: some View {
        NowView()
			.preferredColorScheme(.dark)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
		
		NowView()
			.preferredColorScheme(.light)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}
