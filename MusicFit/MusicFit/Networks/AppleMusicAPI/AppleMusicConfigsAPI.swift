//
//  AppleMusicConfigsAPI.swift
//  MusicFit
//
//  Created by Derrick Ding on 6/26/23.
//

import Foundation
import Alamofire
import StoreKit

extension AppleMusicAPIBase {
    static func getUserToken() async -> String? {
        await withCheckedContinuation { continuation in
            SKCloudServiceController().requestUserToken(forDeveloperToken: Configs.DEVELOPER_TOKEN) { (userToken, error) in
                guard error == nil else { return }
                
                continuation.resume(returning: userToken)
            }
        }
    }
    
    static func getAppleMusicStorefrontID() async -> String? {
        do {
            if let userToken = await getUserToken() {
                // headers specification
                var httpHeaders: HTTPHeaders = Configs.APPLE_MUSIC_API_BASE_HEADERS
                httpHeaders.add(HTTPHeader(name: "Music-User-Token", value: userToken))
                
                let data = try await NetworkManager.shared.request(
                    baseURL: Configs.APPLE_MUSIC_API_URL,
                    route: "/v1/me/storefront",
                    method: .get,
                    parameters: nil,
                    headers: httpHeaders
                )
                
                let appleMusicStorefrontResponse: AppleMusicStorefrontResponse = try self.parseData(data)
                
                return appleMusicStorefrontResponse.data[0].id
                
            } else {
                return nil
            }
        } catch let error {
            print(error.localizedDescription)
            
            return nil
        }
    }
}
