//
//  GameConstants.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 4/18/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct GameRating {
    static let rating = ["E", "E10+", "T", "M", "AO", "Unrated"]
}

struct GameState {
    static let status = ["Owned", "Digital", "Borrowed", "Loaned", "Wishlist", "Unknown"]
}

struct GameBrands {
    static let brands = [
        "Nintendo", "Sony", "Xbox", "PC", "Sega", "Other", "Mobile"
    ].sorted()
}

struct GameSystems {
    static let systems = [
        "Switch", "Switch2", "Wii U", "Wii", "GameCube", "N64", "SNES", "NES",
        "PlayStation 5", "PlayStation 4", "PlayStation 3", "PlayStation 2", "PlayStation", "PSP", "PS Vita",
        "Xbox Series S/X", "Xbox One", "Xbox 360", "Xbox",
        "Windows", "Mac", "Steam", "Epic", "GOG",
        "Genesis", "GameGear", "Saturn", "Sega CD",
        "Mobile", "iOS", "PlayStore",
        "Other"
    ].sorted()
    
    // Static dictionary to map brands to their associated systems
    static let brandSystems: [String: [String]] = [
        "Nintendo": ["Switch", "Switch2", "Wii U", "Wii", "GameCube", "N64", "SNES", "NES", "Other"],
        "Sony": ["PlayStation 5", "PlayStation 4", "PlayStation 3", "PlayStation 2", "PlayStation", "PSP", "PS Vita", "Other"],
        "Xbox": ["Xbox Series S/X", "Xbox One", "Xbox 360", "Xbox", "Other"],
        "PC": ["Windows", "Mac", "Steam", "Epic", "GOG", "Other"],
        "Sega": ["Genesis", "GameGear", "Saturn", "Sega CD", "Other"],
        "Mobile": ["iOS", "PlayStore"],
        "Other": ["Other"] // Default or miscellaneous systems
    ]
    
    // Helper function to get systems for a given brand
    static func systems(for brand: String?) -> [String] {
        guard let brand = brand,
              let systems = brandSystems[brand] else {
            return brandSystems["Other"] ?? [] // Fallback if brand is not found
        }
        return systems.sorted() // Always return sorted systems
    }
}

struct GameGenres {
    static let genre = [
        "Action",
        "Adventure",
        "Action-Adventure",
        "RPG",
        "Strategy",
        "Sports",
        "Puzzle",
        "Racing",
        "Simulation",
        "Shooter",
        "Other",
        "None"].sorted()
}

struct GameLocation {
    static let location = [
        "Physical",
        "Digital",
        "Steam",
        "GamePass",
        "PS Plus",
        "Nintendo Online",
        "Epic Games Store",
        "GOG",
        "Meta VR",
        "Other",
        "None"].sorted()
}

struct GameLocationIconView: View {
    let location: String
    let iconNames: [String: String] = [
        "Physical": "collection",
        "Digital": "cloud",
        "Steam": "steam",
        "GamePass": "xbox",
        "PS Plus": "playstation",
        "Nintendo Online": "nintendo-switch",
        "Epic Games Store": "appstore",
        "GOG": "",
        "Meta VR": "headset-vr",
        "Other": "",
        "None": ""
    ]

    var body: some View {
        Image(iconNames[location, default: "info-circle"]) // Use default icon
            .resizable()
            .scaledToFit()
            .padding(4)
            .frame(width: 20, height: 20)
            .foregroundStyle(.text)
    }
}
