//
//  RatingResponse.swift
//  MusicFit
//
//  Created by Derrick Ding on 6/25/23.
//

import Foundation

struct RatingAttributes: Codable {
    var value: Int
}

struct RatingData: Codable {
    var id: String
    var type: String
    var href: String
    var attributes: RatingAttributes
}

struct RatingResponse: Codable {
    var data: [RatingData]
}
