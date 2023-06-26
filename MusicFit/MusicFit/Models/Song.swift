//
//  Song.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/7/22.
//

import Foundation
import MusicKit

enum Rating {
    case likes
    case dislikes
    case unset
}

struct Song: Identifiable {
	var id: String
	var name: String
	var artistName: String
	var artworkURL: String  // Cover image URL
    var genreNames: [String]  // ["Pop", "Music", ...]
	var likes: Rating
	var durationInMillis: Int
	
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
//
//struct SongAttributes: Codable {
//    var albumName: String
//    var genreNames: [String]
//    var trackNumber: Int
//    var releaseDate: String
//    var durationInMillis: Int
//    var isrc: String
//    var artwork: SongArtwork
//    var composerName: String
//    var playParams: SongPlayParams
//    var url: String
//    var discNumber: Int
//    var isAppleDigitalMaster: Bool
//    var hasLyrics: Bool
//    var name: String
//    var previews: [SongPreview]
//    var artistName: String
//}
//
//struct SongArtwork: Codable {
//    var width: Double
//    var height: Double
//    var url: String
//    var bgColor: String
//    var textColor1: String
//    var textColor2: String
//    var textColor3: String
//    var textColor4: String
//}
//
//struct SongPlayParams: Identifiable, Codable {
//    var id: String
//    var kind: String
//}
//
//struct SongPreview: Codable {
//    var url: String
//}
//
//struct AppleMusicAlbumEntry: Identifiable, Codable {
//    var id: String
//    var type: String
//    var href: String
//}
//
//struct AppleMusicAlbums: Codable {
//    var href: String
//    var data: [AppleMusicAlbumEntry]
//}
//
//struct AppleMusicCatalogSongArtistEnry: Identifiable, Codable {
//    var id: String
//    var type: String
//    var href: String
//}
//
//struct AppleMusicCatalogSongArtists: Codable {
//    var href: String
//    var data: [AppleMusicCatalogSongArtistEnry]
//}
//
//struct SongRelationships: Codable {
//    var albums: AppleMusicAlbums
//    var artists: AppleMusicCatalogSongArtists
//}
//
//struct AppleMusicCatalogSong: Identifiable, Codable {
//    var id: String
//    var type: String
//    var href: String
//    var attributes: SongAttributes
//    var relationships: SongRelationships
//}

struct AppleMusicCatalogSongResponse: Codable {
    var data: [MusicKit.Song]
}
