//
//  PlaylistFolder.swift
//  MusicFit
//
//  Created by Derrick Ding on 6/26/23.
//

import Foundation

struct PlaylistFolderAttributes: Codable {
    var name: String
    var dateAdded: String
}

struct PlaylistFolder: Codable {
    var id: String
    var type: String
    var href: String
    var attributes: PlaylistFolderAttributes
}

struct AppleMusicMeLibraryPlaylistFolderResponse: Codable {
    var data: [PlaylistFolder]
}
