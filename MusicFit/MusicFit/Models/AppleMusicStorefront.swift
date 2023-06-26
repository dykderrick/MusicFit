//
//  AppleMusicStorefront.swift
//  MusicFit
//
//  Created by Derrick Ding on 6/25/23.
//

import Foundation

struct AppleMusicStorefrontAttributes: Codable {
    var supportedLanguageTags: [String]
    var explicitContentPolicy: String
    var name: String
    var defaultLanguageTag: String
}

struct AppleMusicStorefront:Identifiable, Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case typeString = "type"
        case href
        case attributes
    }
    
    var id: String
    var typeString: String
    var href: String
    var attributes: AppleMusicStorefrontAttributes
}

struct AppleMusicStorefrontResponse: Codable {
    var data: [AppleMusicStorefront]
}
