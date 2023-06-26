//
//  AppleMusicPlaylistsAPI.swift
//  MusicFit
//
//  Created by Derrick Ding on 6/26/23.
//

import Foundation
import Alamofire
import MusicKit

extension AppleMusicAPIBase {
    static func getAllLibraryPlaylists() async -> [MusicKit.Playlist]? {
        do {
            if let userToken = await getUserToken() {
                // headers specification
                var httpHeaders: HTTPHeaders = Configs.APPLE_MUSIC_API_BASE_HEADERS
                httpHeaders.add(HTTPHeader(name: "Music-User-Token", value: userToken))
                
                let data = try await NetworkManager.shared.request(
                    baseURL: Configs.APPLE_MUSIC_API_URL,
                    route: "/v1/me/library/playlists",
                    method: .get,
                    parameters: nil,
                    headers: httpHeaders
                )
                
                let appleMusicMeLibraryPlaylistsResponse: AppleMusicMeLibraryPlaylistsResponse = try self.parseData(data)
                
                return appleMusicMeLibraryPlaylistsResponse.data
                
            } else {
                return nil
            }
        } catch let error {
            print(error.localizedDescription)
            
            return nil
        }
    }
    
    static func getLibraryPlaylist(id playlistId: String) async -> MusicKit.Playlist? {
        do {
            if let userToken = await getUserToken() {
                // headers specification
                var httpHeaders: HTTPHeaders = Configs.APPLE_MUSIC_API_BASE_HEADERS
                httpHeaders.add(HTTPHeader(name: "Music-User-Token", value: userToken))
                
                let data = try await NetworkManager.shared.request(
                    baseURL: Configs.APPLE_MUSIC_API_URL,
                    route: "/v1/me/library/playlists/\(playlistId)",
                    method: .get,
                    parameters: nil,
                    headers: httpHeaders
                )
                
                let appleMusicMeLibraryPlaylistsResponse: AppleMusicMeLibraryPlaylistsResponse = try self.parseData(data)
                
                return appleMusicMeLibraryPlaylistsResponse.data.first
            } else {
                return nil
            }
        } catch let error {
            print(error.localizedDescription)
            
            return nil
        }
    }
    
    //    static func getLibraryPlaylistTracks(id playlistId: String) async -> [MusicKit.Song]? {
    //        do {
    //            if let userToken = await getUserToken() {
    //                // headers specification
    //                var httpHeaders: HTTPHeaders = Configs.APPLE_MUSIC_API_BASE_HEADERS
    //                httpHeaders.add(HTTPHeader(name: "Music-User-Token", value: userToken))
    //
    //                let data = try await NetworkManager.shared.get(
    //                    baseURL: Configs.APPLE_MUSIC_API_URL,
    //                    route: "/v1/me/library/playlists/\(playlistId)/tracks",
    //                    parameters: ["limit": 100],
    //                    headers: httpHeaders
    //                )
    //
    //                // TODO: Handle offset and limit: might related to frontend logic
    //
    //
    //            }
    //        }
    //    }
    
    static func createLibraryPlaylist(
        name: String,
        description: String,
        containing trackIds: [String],
        at parentFolderId: String)
    
    async -> MusicKit.Playlist? {
        do {
            if let userToken = await getUserToken() {
                // headers specification
                var httpHeaders: HTTPHeaders = Configs.APPLE_MUSIC_API_BASE_HEADERS
                httpHeaders.add(HTTPHeader(name: "Music-User-Token", value: userToken))
                
                var tracksData = [[String: String]]()
                for trackId in trackIds {
                    tracksData.append([
                        "id": trackId,
                        "type": "songs"
                    ])
                }
                
                // JSON Body
                let bodyParameters: [String : Any] = [
                    "attributes": [
                        "name": name,
                        "description": description
                    ],
                    "relationships": [
                        "tracks": [
                            "data": tracksData
                        ],
                        "parent": [
                            "data": [
                                [
                                    "id": parentFolderId,
                                    "type": "library-playlist-folders"
                                ]
                            ]
                        ]
                    ]
                ]
                
                let data = try await NetworkManager.shared.request(
                    baseURL: Configs.APPLE_MUSIC_API_URL,
                    route: "/v1/me/library/playlists",
                    method: .post,
                    parameters: bodyParameters,
                    headers: httpHeaders
                )
                
                let appleMusicMeLibraryPlaylistsResponse: AppleMusicMeLibraryPlaylistsResponse = try self.parseData(data)
                
                return appleMusicMeLibraryPlaylistsResponse.data.first
            } else {
                return nil
            }
        } catch let error {
            print(error.localizedDescription)
            
            return nil
        }
    }
    
    static func createLibraryPlaylistFolder(name: String, at parentFolderId: String) async -> PlaylistFolder? {
        do {
            if let userToken = await getUserToken() {
                // headers specification
                var httpHeaders: HTTPHeaders = Configs.APPLE_MUSIC_API_BASE_HEADERS
                httpHeaders.add(HTTPHeader(name: "Music-User-Token", value: userToken))
                
                // JSON Body
                let bodyParameters: [String : Any] = [
                    "attributes": [
                        "name": name
                    ],
                    "relationships": [
                        "parent": [
                            "data": [
                                [
                                    "id": parentFolderId,
                                    "type": "library-playlist-folders"
                                ]
                            ]
                        ]
                    ]
                ]
                
                let data = try await NetworkManager.shared.request(
                    baseURL: Configs.APPLE_MUSIC_API_URL,
                    route: "/v1/me/library/playlist-folders",
                    method: .post,
                    parameters: bodyParameters,
                    headers: httpHeaders
                )
                
                let appleMusicMeLibraryPlaylistFoldersResponse: AppleMusicMeLibraryPlaylistFolderResponse = try self.parseData(data)
                
                return appleMusicMeLibraryPlaylistFoldersResponse.data.first
            } else {
                return nil
            }
        } catch let error {
            print(error.localizedDescription)
            
            return nil
        }
    }
}
