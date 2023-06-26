//
//  AppleMusicAPIBase.swift
//  MusicFit
//
//  Created by Derrick Ding on 6/26/23.
//

import Foundation

class AppleMusicAPIBase {
    static func parseData<T: Decodable>(_ data: Data) throws -> T {
        guard let decodedData = try? JSONDecoder().decode(T.self, from: data)
                
        else {
            throw NSError(
                domain: "NetworkAPIError",
                code: 3,
                userInfo: [NSLocalizedDescriptionKey: "\(T.self) JSON decode error"]
            )
        }
        
        return decodedData
    }
}
