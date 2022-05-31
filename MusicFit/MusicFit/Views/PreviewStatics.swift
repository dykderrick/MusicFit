//
//  PreviewStatics.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/31/22.
//

import Foundation

struct PreviewStatics {
	static let previewSong = Song(
		id: "1450695739",
		name: "bad guy",
		artistName: "Billie Eillish",
		artworkURL: "https://is3-ssl.mzstatic.com/image/thumb/Music115/v4/1a/37/d1/1a37d1b1-8508-54f2-f541-bf4e437dda76/19UMGIM05028.rgb.jpg/{w}x{h}bb.jpg",
		genreNames: [""],
		durationInMillis: 194088
	)
	
	static let previewPlaylist = Playlist(
		id: "p.aJe00RDi3VKaQJa",
		name: "Resting",
		description: "This is MusicFit playlist for resting.",
		isPublic: false,
		canEdit: true,
		dateAdded: Date(),
		artworkURL: ""
	)
}
