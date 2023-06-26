//
//  Color.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/31/22.
//

import Foundation
import SwiftUI

extension Color {
    static let musicFitGreen = Color(hex: "25E495")
    static let musicFitGray = Color(hex: "D8D8D8")
    
    /// A color specification by hex code.
    /// Credit to the [Stack Overflow answer](https://stackoverflow.com/questions/56874133/use-hex-color-in-swiftui).
    ///
    /// ```
    /// let customedWhite = Color(hex: "#FFFFFF")
    /// let customedBlack = Color(hex: "000000")
    /// ```
    ///
    /// - Parameters:
    ///   - hex: A hex code `String` to represent a color. Can be a six-character-string with or without hashtag in the beginning.
    ///
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
