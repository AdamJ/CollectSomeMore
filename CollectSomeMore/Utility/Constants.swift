//
//  Constants.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/30/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

let gradientColors: [Color] = [
    .transparent,
    .gradientTop,
    .gradientBottom,
    .transparent
]
let transparentGradient: [Color] = [
    .backgroundTertiary,
    .transparent
]
let transparentGradientInverse: [Color] = [
    .transparent,
    .backgroundTertiary
]
let darkBottom: [Color] = [
    .transparent,
    .gradientBottom
]

struct Constants {
    static let SpacerNone: CGFloat = 0
    static let SpacerXSmall: CGFloat = 4
    static let SpacerSmall: CGFloat = 8
    static let SpacerMedium: CGFloat = 16
    static let SpacerLarge: CGFloat = 24
    static let SpacerXLarge: CGFloat = 32
    static let SpacerTitle: CGFloat = 48
    static let SpacerHeader: CGFloat = 72
}

struct Colors {
    static let primary: Color = .primary
    static let secondary: Color = .secondary
    static let accent: Color = .accentColor
    static let link: Color = .linkText
}

struct TransparentOutlineStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundStyle(.tint)
            .background(
                RoundedRectangle(
                    cornerRadius: 20,
                    style: .continuous
                )
                .stroke(.tint, lineWidth: 2)
            )
    }
}

extension ButtonStyle where Self == TransparentOutlineStyle {
    static var transparentOutline: Self {
        return .init()
    }
}
//Button("Transparent Outline Button") {
//}
//.buttonStyle(.TransparentOutline)
//.tint(.accentColor)

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(
                    cornerRadius: 20,
                    style: .continuous
                )
                .fill(.tint)
                .stroke(.tint, lineWidth: 2)
            )
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primaryButton: Self {
        return .init()
    }
}
//Button("Primary Button") {
//}
//.buttonStyle(.primaryButton)
//.tint(.primaryApp)
