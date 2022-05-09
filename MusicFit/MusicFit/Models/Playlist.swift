//
//  Playlist.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/9/22.
//

import Foundation

struct Playlist {
    var id: String
    var name: String
    var description: String
    var isPublic: Bool
    var canEdit: Bool
    var dateAdded: Date
    var artworkURL: String
    
    init(id: String, name: String, description: String, isPublic: Bool, canEdit: Bool, dateAdded: Date, artworkURL: String) {
        self.id = id
        self.name = name
        self.description = description
        self.isPublic = isPublic
        self.canEdit = canEdit
        self.dateAdded = dateAdded
        self.artworkURL = artworkURL
    }
    
}
