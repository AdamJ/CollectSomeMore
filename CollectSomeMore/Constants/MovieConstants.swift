//
//  MovieConstants.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 4/18/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct Rating {
    static let rating = [
        "NR",
        "G",
        "PG",
        "PG-13",
        "R",
        "Unrated"
    ]
}

struct Location {
    static let location = [
        "Physical",
        "iTunes",
        "Network",
        "Other",
        "None"
    ]
}

struct LocationIconView: View {
    let location: String
    let iconNames: [String: String] = [
        "Physical": "tag",
        "iTunes": "tv.and.mediabox",
        "Network": "externaldrive.badge.wifi",
        "Other": "questionmark.circle.dashed",
        "None": ""
    ]

    var body: some View {
        Image(systemName: iconNames[location, default: "questionmark.circle"]) // Use default icon
            .resizable()
            .scaledToFit()
            .padding(4)
            .frame(width: 20, height: 20)
            .foregroundStyle(.text)
    }
}

struct Platform {
    static let platforms = [
        "All", // for filtering purposes
        "Blu-ray",
        "DVD",
        "Streaming",
        "Other",
        "None"]
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
            .frame(width: 20, height: 20)
            .foregroundStyle(.text)
    }
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
        "Paramount+",
        "None"].sorted()
}

struct Studios {
    static let studios = [
        "All", // for filtering purposes
        "Amazon",
        "Apple",
        "Disney",
        "Indie",
        "Marvel Studios",
        "Paramount Pictures",
        "Studio Ghibli",
        "Sony Pictures",
        "20th Century Fox",
        "Universal Pictures",
        "Unknown",
        "Warner Bros",
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
