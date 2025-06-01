//
//  Collection.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/20/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import Foundation
import SwiftData

@Model
class MovieCollection {
    @Attribute var id = UUID()
    var movieTitle: String?
    var ratings: String?
    var genre: String?
    var studio: String?
    var platform: String?
    var service: String?
    var releaseDate: Date?
    var purchaseDate: Date?
    var locations: String?
    var enteredDate: Date?
    var notes: String = ""
    var isWatched: Bool = false

    init(id: UUID = UUID(), movieTitle: String? = nil, ratings: String? = nil, genre: String? = nil, studio: String? = nil, platform: String? = nil, service: String? = nil, releaseDate: Date? = nil, purchaseDate: Date? = nil, locations: String? = nil, enteredDate: Date? = nil, notes: String? = nil, isWatched: Bool = false) {
        self.id = id
        self.movieTitle = movieTitle
        self.ratings = ratings
        self.genre = genre
        self.studio = studio
        self.platform = platform
        self.service = service
        self.releaseDate = releaseDate
        self.purchaseDate = purchaseDate
        self.locations = locations
        self.enteredDate = enteredDate ?? Date()
        self.notes = notes ?? ""
        self.isWatched = isWatched
    }

    @MainActor static let sampleCollectionData = [
        MovieCollection(
            id: UUID(),
            movieTitle: "Warriors of the Wind",
            ratings: "G",
            genre: "Animated",
            studio: "None",
            platform: "Streaming",
            service: "Disney+",
            releaseDate: .now,
            purchaseDate: .now,
            locations: "Storage",
            enteredDate: .now,
            notes: "One of my favorite movies.",
            isWatched: false
        )
    ]
}
