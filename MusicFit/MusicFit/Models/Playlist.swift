//
//  Playlist.swift
//  MusicFit
//
//  Created by 丁盈科 on 5/9/22.
//

import Foundation

struct Playlist {
    var id: String
    var name: String
    var isPublic: Bool
    var canEdit: Bool
    var dateAdded: Date
    
    init(id: String, name: String, isPublic: Bool, canEdit: Bool, dateAdded: Date) {
        self.id = id
        self.name = name
        self.isPublic = isPublic
        self.canEdit = canEdit
        self.dateAdded = dateAdded
    }
    
}
