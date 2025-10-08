//
//  ComicConstants.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 9/8/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct ComicRating {
    static let rating = [
        "E", // Everyone
        "T", // Teen
        "T+", // Teen Plus
        "M", // Mature
        "AO", // Adults Only
        "Unrated"
    ]
}

struct ComicPublishers {
    static let publishers = [
        "Marvel Comics",
        "DC Comics",
        "Image Comics",
        "Dark Horse Comics",
        "IDW Publishing",
        "BOOM! Studios",
        "Dynamite Entertainment",
        "Valiant Entertainment",
        "Archie Comics",
        "Oni Press",
        "Avatar Press",
        "Top Cow Productions",
        "Vertigo",
        "WildStorm",
        "Independent",
        "Other",
        "Unknown"
    ].sorted()
}

struct ComicGenres {
    static let genres = [
        "Superhero",
        "Action",
        "Adventure",
        "Science Fiction",
        "Fantasy",
        "Horror",
        "Mystery",
        "Crime",
        "Romance",
        "Comedy",
        "Drama",
        "Western",
        "War",
        "Historical",
        "Biography",
        "Slice of Life",
        "Anthology",
        "Manga",
        "Graphic Novel",
        "Mini-Series",
        "One-Shot",
        "Educational",
        "Children's",
        "Other"
    ].sorted()
}

struct ComicLocation {
    static let location = [
        "Physical",
        "Digital",
        "ComiXology",
        "Marvel Unlimited",
        "DC Universe Infinite",
        "Kindle",
        "Apple Books",
        "Google Play Books",
        "Library",
        "Subscription Service",
        "Other",
        "None"
    ].sorted()
}

struct ComicCondition {
    static let condition = [
        "Mint (M)",
        "Near Mint (NM)",
        "Very Fine (VF)",
        "Fine (F)",
        "Very Good (VG)",
        "Good (G)",
        "Fair (FR)",
        "Poor (P)",
        "Digital",
        "N/A"
    ]
}

struct ComicLocationIconView: View {
    let location: String
    let iconNames: [String: String] = [
        "Physical": "book.closed",
        "Digital": "ipad",
        "ComiXology": "tablet",
        "Marvel Unlimited": "infinity",
        "DC Universe Infinite": "app.badge",
        "Kindle": "kindle",
        "Apple Books": "books.vertical",
        "Google Play Books": "book",
        "Library": "building.columns",
        "Subscription Service": "app.connected.to.app.below.fill",
        "Other": "questionmark.circle",
        "None": ""
    ]

    var body: some View {
        Image(systemName: iconNames[location, default: "book"]) // Use default icon
            .resizable()
            .scaledToFit()
            .padding(4)
            .frame(width: 20, height: 20)
            .foregroundStyle(.text)
    }
}

struct ComicConditionIconView: View {
    let condition: String
    let iconNames: [String: String] = [
        "Mint (M)": "star.fill",
        "Near Mint (NM)": "star.leadinghalf.filled",
        "Very Fine (VF)": "checkmark.seal",
        "Fine (F)": "checkmark.circle",
        "Very Good (VG)": "hand.thumbsup",
        "Good (G)": "minus.circle",
        "Fair (FR)": "exclamationmark.triangle",
        "Poor (P)": "xmark.circle",
        "Digital": "icloud",
        "N/A": ""
    ]

    var body: some View {
        Image(systemName: iconNames[condition, default: "questionmark.circle"]) // Use default icon
            .resizable()
            .scaledToFit()
            .padding(4)
            .frame(width: 20, height: 20)
            .foregroundStyle(.text)
    }
}