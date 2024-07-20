//
//  UiColor.swift
//  CultureTrek
//
//  Created by Giorgi Michitashvili on 7/9/24.
//

import UIKit
import SwiftUI

extension UIColor {
    convenience init(hex: String) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.currentIndex = scanner.string.index(after: scanner.currentIndex)
        }
        
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        
        let r, g, b, a: CGFloat
        switch hexString.count {
        case 6:
            r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            b = CGFloat(color & 0x0000FF) / 255.0
            a = 1.0
        case 8:
            r = CGFloat((color & 0xFF000000) >> 24) / 255.0
            g = CGFloat((color & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((color & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(color & 0x000000FF) / 255.0
        default:
            r = 0
            g = 0
            b = 0
            a = 1.0
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

extension Color {
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
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
