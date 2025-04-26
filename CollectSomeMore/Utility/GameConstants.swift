//
//  GameConstants.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 4/18/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct GameRatings {
    static let ratings = ["E", "E10+", "T", "M", "AO", "R", "NR", "Unknown"]
}

struct GameBrands {
    static let brands = ["Any", "None", "Nintendo", "PlayStation", "Xbox", "Sega", "PC", "Apple", "Android"].sorted()
}

struct GameSystems {
    static let systems = ["All", "NES", "SNES", "N64", "GameCube", "Wii", "Wii U", "Switch", "Vita", "PSP", "Xbox", "Xbox 360", "Xbox One", "Xbox Series S/X", "PS1", "PS2", "PS3", "PS4", "PS5", "Other", "None", "PC", "MetaStore", "AppStore", "PlayStore", "Genesis", "GameGear", "Saturn", "Sega CD"].sorted()
}

struct GameLocations {
    static let location = ["Cabinet", "Steam", "GamePass", "PlayStation Plus", "Nintendo Switch Online", "Epic Game Store", "Other", "None"].sorted()
}

struct GameGenres {
    static let genre = ["Action", "Adventure", "Role-Playing", "Strategy", "Sports", "Puzzle", "Racing", "Simulation", "Shooter", "Other", "None"].sorted()
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
