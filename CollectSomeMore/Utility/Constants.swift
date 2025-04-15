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

struct CollectionState {
    static let owned: String = "Owned"
    static let digital: String = "Digital"
    static let borrowed: String = "Borrowed"
    static let loaned: String = "Loaned"
    static let unknown: String = "Unknown"
}

struct BrandIconView: View {
    let brand: String
    let iconNames: [String: String] = [
        "Quest": "headset-vr",
        "Android": "goole-play",
        "Other": "info-circle",
        "Sega": "disc",
        "None": "system-horizontal"
    ]
    
    var body: some View {
        Image(iconNames[brand, default: "collection"])
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
    }
}

struct LocationIconView: View {
    let locations: String
    let iconNames: [String: String] = [
        "Cabinet": "tag",
        "iTunes": "tv.and.mediabox",
        "Network": "externaldrive.badge.wifi",
        "Other": "questionmark.circle.dashed",
        "None": ""
    ]

    var body: some View {
        Image(systemName: iconNames[locations, default: "questionmark.circle"]) // Use default icon
            .resizable()
            .scaledToFit()
            .padding(4)
            .frame(width: 28, height: 28)
            .foregroundStyle(.text)
    }
}

struct GameLocationIconView: View {
    let locations: String
    let iconNames: [String: String] = [
        "Local": "collection",
        "Steam": "steam",
        "Online": "cloud",
        "Other": "info-circle",
        "None": ""
    ]

    var body: some View {
        Image(iconNames[locations, default: "info-circle"]) // Use default icon
            .resizable()
            .scaledToFit()
            .padding(4)
            .frame(width: 28, height: 28)
            .foregroundStyle(.text)
    }
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
