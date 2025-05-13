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
    static func opensans(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .regular:
            return .custom("OpenSans-Regular", size: size)
        case .bold:
            return .custom("OpenSans-Bold", size: size)
        case .heavy, .black:
            return .custom("OpenSans-ExtraBold", size: size)
        case .light, .thin, .ultraLight:
            return .custom("OpenSans-Light", size: size)
        case .semibold:
            return .custom("OpenSans-SemiBold", size: size)
        default:
            return .custom("OpenSans-Regular", size: size) // Default to regular if weight is not matched
        }
    }
}

// Modify the environment to use Oswald as the default font family.
struct OpensansFontModifier: ViewModifier {
    let size: CGFloat
    let weight: Font.Weight

    func body(content: Content) -> some View {
        content
            .font(.opensans(size: size, weight: weight))
    }
}

struct LargeTitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .opensansFont(size: 48, weight: .bold)
    }
}

struct LargeSubtitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .opensansFont(size: 32, weight: .bold)
    }
}

struct TitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .opensansFont(size: 24, weight: .bold)
    }
}

struct Title2Style: ViewModifier {
    func body(content: Content) -> some View {
        content
            .opensansFont(size: 22, weight: .bold)
    }
}

struct Title3Style: ViewModifier {
    func body(content: Content) -> some View {
        content
            .opensansFont(size: 20, weight: .bold)
    }
}

struct SubtitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .opensansFont(size: 18, weight: .semibold)
    }
}

struct BodyStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .opensansFont(size: 16)
    }
}

struct LinkStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .opensansFont(size: 16)
            .foregroundStyle(.linkText)
    }
}

struct BodyBoldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .opensansFont(size: 16, weight: .bold)
    }
}

struct CaptionStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .opensansFont(size: 14, weight: .semibold)
    }
}

struct MinimalStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .opensansFont(size: 12, weight: .regular)
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
    func linkStyle() -> some View {
        self.modifier(LinkStyle())
    }
    func bodyBoldStyle() -> some View {
        self.modifier(BodyBoldStyle())
    }
    func captionStyle() -> some View {
        self.modifier(CaptionStyle())
    }
    func minimalStyle() -> some View {
        self.modifier(MinimalStyle())
    }

    func opensansFont(size: CGFloat, weight: Font.Weight = .regular) -> some View {
        self.modifier(OpensansFontModifier(size: size, weight: weight))
    }
}

struct FontDemoView: View {
    var body: some View {
        VStack {
            Text("Large Title Text Style")
                .largeTitleStyle()
            
            Text("Large Subtitle Text Style")
                .largeSubtitleStyle()

            Text("Title (H1) Style")
                .titleStyle()

            Text("Title (H2) Style")
                .title2Style()

            Text("Title (H3) Style")
                .title3Style()

            Text("Subtitle Text Style")
                .subtitleStyle()
            
            Text("Default System Font")
                .bodyStyle()
            
            Text("Default Link Text")
                .linkStyle()
            
            Text("Body Style Bold")
                .bodyBoldStyle()
            
            Text("Caption Style")
                .captionStyle()
            
            Text("Minimal Text Style")
                .minimalStyle()
        }
    }
}

#Preview("Font Demo") {
    FontDemoView()
}
