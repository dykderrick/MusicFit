//
//  AppleMusicSongsAPI.swift
//  MusicFit
//
//  Created by Derrick Ding on 6/26/23.
//

import Foundation
import Alamofire
import MusicKit

extension AppleMusicAPIBase {
    static func getAppleMusicCatalogSong(id catalogSongId: String, atStore storefrontId: String) async -> MusicKit.Song? {
        do {
            let data = try await NetworkManager.shared.request(
                baseURL: Configs.APPLE_MUSIC_API_URL,
                route: "/v1/catalog/\(storefrontId)/songs/\(catalogSongId)",
                method: .get,
                parameters: nil,
                headers: Configs.APPLE_MUSIC_API_BASE_HEADERS
            )
            
            let appleMusicCatalogSongResponse: AppleMusicCatalogSongResponse = try self.parseData(data)
            
            return appleMusicCatalogSongResponse.data.first
        } catch let error {
            print(error.localizedDescription)
            
            return nil
        }
    }
}
