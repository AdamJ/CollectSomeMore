//
//  TestPreviews.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 6/6/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//
import SwiftUI
import SwiftData
import Foundation

#Preview("Movie Detail View") {
    let sampleMovie = CD_MovieCollection(
        id: UUID(),
        movieTitle: "Warriors of the Wind",
        ratings: "G",
        genre: "Animated",
        studio: "None",
        platform: "None",
        releaseDate: .now,
        purchaseDate: .now,
        locations: "Storage",
        enteredDate: .now,
        notes: "One of my favorite movies.",
        isWatched: true
        )
        return MovieDetail(movieCollection: sampleMovie)
            .modelContainer(for: [CD_MovieCollection.self])
}


#Preview("Game Detail View") {
    let sampleGame = CD_GameCollection(
        id: UUID(),
        collectionState: "Owned",
        gameTitle: "Halo: Infinite",
        brand: "Xbox",
        system: "Xbox Series S/X",
        rating: "M",
        genre: "Action",
        purchaseDate: Date(),
        locations: "Cabinet",
        notes: "Need to try this out with friends.",
        enteredDate: Date(),
        isPlayed: false
    )
    return GameDetailView(gameCollection: sampleGame)
        .modelContainer(for: [CD_GameCollection.self])
}
