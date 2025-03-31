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
    var releaseDate: Date?
    var purchaseDate: Date?
    var locations: String?
    var enteredDate: Date?

    init(id: UUID = UUID(), movieTitle: String? = nil, ratings: String? = nil, genre: String? = nil, releaseDate: Date? = nil, purchaseDate: Date? = nil, locations: String? = nil, enteredDate: Date? = nil) {
        self.id = id
        self.movieTitle = movieTitle
        self.ratings = ratings
        self.genre = genre
        self.releaseDate = releaseDate
        self.purchaseDate = purchaseDate
        self.locations = locations
        self.enteredDate = enteredDate
    }

    @MainActor static let sampleCollectionData = [
        MovieCollection(
            id: UUID(),
            movieTitle: "Warriors of the Wind",
            ratings: "G",
            genre: "Animated",
            releaseDate: .now,
            purchaseDate: .now,
            locations: "Cabinet",
            enteredDate: .now
        )
    ]
}
