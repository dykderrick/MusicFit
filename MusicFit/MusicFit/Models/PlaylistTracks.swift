//
//  PlaylistTracks.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/9/22.
//

import Foundation

struct PlaylistTracks {
    var playlistId: String
    var trucks: [Song]
    
    init(playlistId: String, trucks: [Song]) {
        self.playlistId = playlistId
        self.trucks = trucks
    }
}
