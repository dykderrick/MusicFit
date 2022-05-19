//
//  PlaylistTracks.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/9/22.
//

import Foundation

struct PlaylistTracks {
    var playlistId: String
    var tracks: [Song]
    
    init(playlistId: String, tracks: [Song]) {
        self.playlistId = playlistId
        self.tracks = tracks
    }
}
