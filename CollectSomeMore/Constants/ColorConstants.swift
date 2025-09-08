//
//  ColorConstants.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/30/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

let backgroundGradient = LinearGradient(
    colors: [Color.backgroundBlue, Color.chipAlt],
    startPoint: .topLeading, endPoint: .bottomTrailing)

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
let cardGradient: [Color] = [
    .backgroundGreenBlueGradient,
    .backgroundBlueGreenGradient
]

struct Sizing {
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
    static let chip: Color = .chip
    static let chipAlt: Color = .chipAlt
    static let inverseOnSurface: Color = .inverseOnSurface
    static let onPrimaryOpacity12: Color = .onPrimaryOpacity12
    static let onSecondaryContainer: Color = .onSecondaryContainer
    static let onSurface: Color = .onSurface
    static let onSurfaceVariant: Color = .onSurfaceVariant
    static let outlineVariant: Color = .outlineVariant
    static let primaryMaterial: Color = .primaryMaterial
    static let secondaryContainer: Color = .secondaryContainer
    static let surfaceContainerLow: Color = .surfaceContainerLow
    static let surfaceLevel: Color = .surfaceLevel
    static let transparent: Color = .clear
    static let androidGreen: Color = .androidGreen
    static let metaBlue: Color = .metaBlue
    static let appleSlate: Color = .appleSlate
    static let steamBlack: Color = .steamBlack
    static let nintendoRed: Color = .nintendoRed
    static let xboxGreen: Color = .xboxGreen
    static let playstationBlack: Color = .playstationBlack
    static let segaBlue: Color = .segaBlue
    static let solidGreen: Color = .solidGreen
    static let oppositeTextColor: Color = .oppositeText
    static let tabBarColors: Color = .tabBar
    static let appOffWhite: Color = .appOffWhite
    static let windowsBlue: Color = .windowsBlue
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

let colors: [String: Color] = ["G": .accentPurple, "PG": .accentGreen, "PG-13": .accentBlue, "R": .accentRed, "NR": .black, "Unrated": .accentGray]

extension Color {
    static func backgroundGameColor(forSectionID sectionID: String) -> Color {
        switch sectionID {
        case "Xbox", "Xbox Series S/X", "Xbox One", "Xbox 360":
            return Colors.xboxGreen
        case "PlayStation 5", "PlayStation 4", "PlayStation 3", "PlayStation 2", "PlayStation", "PSP", "PS Vita":
            return Colors.playstationBlack
        case "Nintendo", "Switch", "Switch2", "Wii U", "Wii", "GameCube", "N64", "SNES", "NES":
            return Colors.nintendoRed
        case "PC", "Mac", "Steam", "Epic", "GOG":
            return Colors.steamBlack
        case "Sega", "Genesis", "GameGear", "Saturn", "Sega CD":
            return Colors.segaBlue
        case "Mobile", "iOS":
            return Colors.appleSlate
        case "PlayStore":
            return Colors.androidGreen
        case "Windows":
            return Colors.windowsBlue
        default:
            return Colors.surfaceContainerLow
        }
    }

    static func foregroundGameColor(forSectionID sectionID: String) -> Color {
        switch sectionID {
        case "Xbox", "Xbox Series S/X", "Xbox One", "Xbox 360", "PlayStation 5", "PlayStation 4", "PlayStation 3", "PlayStation 2", "PlayStation", "PSP", "PS Vita", "Sega", "Genesis", "GameGear", "Saturn", "Sega CD", "PC", "Mac", "Windows", "Steam", "Epic", "GOG", "Nintendo", "Switch", "Switch2", "Wii U", "Wii", "GameCube", "N64", "SNES", "NES", "Unrated":
            return Colors.inverseOnSurface
        case "Mobile", "iOS", "PlayStore":
            return Colors.onSurface
        default: return Colors.onSurface
        }
    }
}
