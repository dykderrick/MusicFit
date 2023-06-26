//
//  AppleMusicRatingsAPI.swift
//  MusicFit
//
//  Created by Derrick Ding on 6/26/23.
//

import Foundation
import Alamofire

extension AppleMusicAPIBase {
    static func getPersonalSongRating(id catalogSongId: String) async -> Rating? {
        // TODO: handle Apple Music API capacity
        /*
         Apple Music API limits the number of requests your app can make using a developer token within a specific period of time.
         If this limit is exceeded, you’ll temporarily receive 429 Too Many Requests error responses for requests that use the token.
         This error resolves itself shortly after the request rate has reduced.
         
         See Also: https://developer.apple.com/documentation/applemusicapi/generating_developer_tokens
         */
        
        do {
            if let userToken = await getUserToken() {
                // headers specification
                var httpHeaders: HTTPHeaders = Configs.APPLE_MUSIC_API_BASE_HEADERS
                httpHeaders.add(HTTPHeader(name: "Music-User-Token", value: userToken))
                
                let data = try await NetworkManager.shared.request(
                    baseURL: Configs.APPLE_MUSIC_API_URL,
                    route: "/v1/me/ratings/songs/\(catalogSongId)",
                    method: .get,
                    parameters: nil,
                    headers: httpHeaders
                )
                
                let personalSongRatingResponse: RatingResponse = try self.parseData(data)
                
                return personalSongRatingResponse.data.first?.attributes.value == 1 ? .likes : .dislikes
            } else {
                return nil
            }
            
        } catch let error {
            print(error.localizedDescription)
            
            return .unset
        }
    }
}
