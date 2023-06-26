//
//  PlaylistTracks.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/9/22.
//

import Foundation
import MusicKit

struct PlaylistTracks {
    var playlistId: String
    var tracks: [Song]
    
    init(playlistId: String, tracks: [Song]) {
        self.playlistId = playlistId
        self.tracks = tracks
    }
}

struct AppleMusicMeLibraryPlaylistRelationshipResponseMeta: Codable {
    var total: Int
}

struct AppleMusicMeLibraryPlaylistRelationshipResponse: Codable {
    var data: [MusicKit.Song]
    var meta: AppleMusicMeLibraryPlaylistRelationshipResponseMeta
}
