//
//  Song.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/7/22.
//

import Foundation

struct Song {
	var id: String
	var name: String
	var artistName: String
	var artworkURL: String  // Cover image URL
    var genreNames: [String]  // ["Pop", "Music", ...]
	
    init(id: String, name: String, artistName: String, artworkURL: String, genreNames: [String]) {
		self.id = id
		self.name = name
		self.artistName = artistName
		self.artworkURL = artworkURL
        self.genreNames = genreNames
	}
}
