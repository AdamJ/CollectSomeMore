//
//  customFonts.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/21/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

extension Font {
//    static func system(size: CGFloat, type:oswaldType = .Regular ) -> Font{
//        self.custom(type.rawValue, size: size)
//    }
    static func system(size: CGFloat, type:openSansType = .Regular ) -> Font{
        self.custom(type.rawValue, size: size)
    }
}

//enum oswaldType: String {
//    case Regular = "Oswald-Regular"
////    case Medium = "Oswald-Medium"
////    case Light = "Oswald-Light"
//    case Semibold = "Oswald-Semibold"
//    case Bold = "Oswald-Bold"
//    case ExtraLight = "Oswald-ExtraLight"
//}

enum openSansType: String {
    case Regular = "OpenSans-Regular"
    case Semibold = "OpenSans-Semibold"
    case Bold = "OpenSans-Bold"
    case ExtraLight = "OpenSans-Light"
}
