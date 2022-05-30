//
//  Song.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/7/22.
//

import Foundation

struct Song: Identifiable {
	var id: String
	var name: String
	var artistName: String
	var artworkURL: String  // Cover image URL
    var genreNames: [String]  // ["Pop", "Music", ...]
	var likes: Rating
	var durationInMillis: Int
	
	enum Rating {
		case likes
		case dislikes
		case unset
	}
	
	init(id: String, name: String, artistName: String, artworkURL: String, genreNames: [String], durationInMillis: Int) {
		self.id = id
		self.name = name
		self.artistName = artistName
		self.artworkURL = artworkURL
        self.genreNames = genreNames
		self.likes = .unset  // TODO: Maybe delete this initializer
		self.durationInMillis = durationInMillis
	}
	
	init(id: String, name: String, artistName: String, artworkURL: String, genreNames: [String], likes: Rating, durationInMillis: Int) {
		self.id = id
		self.name = name
		self.artistName = artistName
		self.artworkURL = artworkURL
		self.genreNames = genreNames
		self.likes = likes
		self.durationInMillis = durationInMillis
	}
}
