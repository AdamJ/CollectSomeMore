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
final class Collection {
    var id: UUID
    var title: String
    var releaseDate: Date
    var purchaseDate: Date
    var genre: String
    var ratings: String
    var locations: String

    init(id: UUID = UUID(), title: String, releaseDate: Date, purchaseDate: Date, genre: String, ratings: String, locations: String) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.purchaseDate = purchaseDate
        self.genre = genre
        self.ratings = ratings
        self.locations = locations
    }

    @MainActor static let sampleData = [
        Collection(
            id: UUID(),
            title: "Deadpool",
            releaseDate: Date(timeIntervalSinceReferenceDate: -402_000_000),
            purchaseDate: Date(timeIntervalSinceNow: -5_000_000),
            genre: "Superhero",
            ratings: "R",
            locations: "Cabinet"
        )
    ]
}
