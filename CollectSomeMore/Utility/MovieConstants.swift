//
//  MovieConstants.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 4/18/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct Locations {
    static let locations = ["Storage", "iTunes", "Network", "Other", "None"]
}

struct LocationIconView: View {
    let locations: String
    let iconNames: [String: String] = [
        "Storage": "tag",
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

struct PlatformIconView: View {
    let platform: String
    let iconNames: [String: String] = [
        "Streaming": "tv.fill",
        "Blu-ray": "movie.fill",
        "DVD": "movie.fill",
        "Other": "questionmark.circle.dashed",
        "None": ""
    ]
    
    var body: some View {
        Image(systemName: iconNames[platform, default: "questionmark.circle"]) // Use default icon
            .resizable()
            .scaledToFit()
            .padding(4)
            .frame(width: 28, height: 28)
            .foregroundStyle(.text)
    }
}

struct Platform {
    static let platforms = [
        "All",
        "Blue-ray",
        "DVD",
        "Streaming",
        "Other",
        "None"]
}

struct Service {
    static let service = [
        "Home Theater",
        "Apple TV+",
        "Prime Video",
        "Apple TV",
        "Netflix",
        "Hulu",
        "Disney+",
        "HBO Max",
        "YouTube",
        "ESPN+",
        "Peacock",
        "None"].sorted()
}

struct Studios {
    static let studios = [
        "All",
        "Amazon",
        "Apple",
        "Disney",
        "Paramount Pictures",
        "Studio Ghibli",
        "Sony Pictures",
        "20th Century Fox",
        "Universal Pictures",
        "Warner Bros.",
        "None"]
}

struct Genres {
    static let genres = [
        "Action",
        "Adventure",
        "Anime",
        "Animated",
        "Biography",
        "Comedy",
        "Documentary",
        "Drama",
        "Educational",
        "Family",
        "Fantasy",
        "Historical",
        "Horror",
        "Indie",
        "Music",
        "Mystery",
        "Romance",
        "Sci-Fi",
        "Superhero",
        "Suspense",
        "Thriller",
        "Western",
        "Other"].sorted()
}
