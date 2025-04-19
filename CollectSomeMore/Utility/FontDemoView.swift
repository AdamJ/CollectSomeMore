//
//  ContentView.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 4/14/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

// Extend Font to include Oswald font weights
extension Font {
    static func oswald(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .regular:
            return .custom("Oswald-Regular", size: size)
        case .bold:
            return .custom("Oswald-Bold", size: size)
        case .heavy, .black:
            return .custom("Oswald-ExtraBold", size: size) // Oswald does not have a "Heavy" or "Black" weight, ExtraBold is the closest.
        case .light, .thin, .ultraLight:
            return .custom("Oswald-ExtraLight", size: size)
        case .semibold:
            return .custom("Oswald-SemiBold", size: size)
        default:
            return .custom("Oswald-Regular", size: size) // Default to regular if weight is not matched
        }
    }
}

// Modify the environment to use Oswald as the default font family.
struct OswaldFontModifier: ViewModifier {
    let size: CGFloat
    let weight: Font.Weight

    func body(content: Content) -> some View {
        content
            .font(.oswald(size: size, weight: weight))
    }
}

struct LargeTitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .oswaldFont(size: 48, weight: .bold)
    }
}

struct LargeSubtitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .oswaldFont(size: 32, weight: .bold)
    }
}

struct TitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .oswaldFont(size: 24, weight: .bold)
    }
}

struct Title2Style: ViewModifier {
    func body(content: Content) -> some View {
        content
            .oswaldFont(size: 22, weight: .bold)
    }
}

struct Title3Style: ViewModifier {
    func body(content: Content) -> some View {
        content
            .oswaldFont(size: 20, weight: .bold)
    }
}

struct SubtitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .oswaldFont(size: 18, weight: .semibold)
    }
}

struct BodyStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .oswaldFont(size: 16)
    }
}

struct BodyBoldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .oswaldFont(size: 16, weight: .bold)
    }
}

struct CaptionStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .oswaldFont(size: 14, weight: .semibold)
    }
}

extension View {
    func largeTitleStyle() -> some View {
        self.modifier(LargeTitleStyle())
    }
    func largeSubtitleStyle() -> some View {
        self.modifier(LargeSubtitleStyle())
    }
    func titleStyle() -> some View {
        self.modifier(TitleStyle())
    }
    func title2Style() -> some View {
        self.modifier(Title2Style())
    }
    func title3Style() -> some View {
        self.modifier(Title3Style())
    }
    func subtitleStyle() -> some View {
        self.modifier(SubtitleStyle())
    }
    func bodyStyle() -> some View {
        self.modifier(BodyStyle())
    }
    func bodyBoldStyle() -> some View {
        self.modifier(BodyBoldStyle())
    }
    func captionStyle() -> some View {
        self.modifier(CaptionStyle())
    }

    func oswaldFont(size: CGFloat, weight: Font.Weight = .regular) -> some View {
        self.modifier(OswaldFontModifier(size: size, weight: weight))
    }
}

struct FontDemoView: View {
    var body: some View {
        VStack {
            Text("Oswald Regular")
                .bodyStyle()

            Text("Oswald Bold")
                .oswaldFont(size: 20, weight: .bold)

            Text("Oswald Extra Light")
                .oswaldFont(size: 20, weight: .light)

            Text("Oswald Semi Bold")
                .oswaldFont(size: 20, weight: .semibold)

            Text("Oswald Extra Bold (Heavy Alternative)")
                .oswaldFont(size: 20, weight: .heavy)

            Text("Default System Font")
        }
    }
}

#Preview("Font Demo") {
    FontDemoView()
}
