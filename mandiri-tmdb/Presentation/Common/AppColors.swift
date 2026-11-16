//
//  AppColors.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import UIKit

enum AppColors {
    static let background = UIColor(hex: 0x0F0F14)
    static let card = UIColor(hex: 0x1C1C24)
    static let accent = UIColor(hex: 0xF5C518)
    static let textPrimary = UIColor.white
    static let textSecondary = UIColor(white: 1, alpha: 0.6)
}

extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: alpha
        )
    }
}
