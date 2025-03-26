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
    var ratings: String
    var genre: String
    var releaseDate: Date
    var purchaseDate: Date
    var locations: String
    var enteredDate: Date

    init(id: UUID = UUID(), title: String, ratings: String, genre: String, releaseDate: Date, purchaseDate: Date, locations: String, enteredDate: Date = .now) {
        self.id = id
        self.title = title
        self.ratings = ratings
        self.genre = genre
        self.releaseDate = releaseDate
        self.purchaseDate = purchaseDate
        self.locations = locations
        self.enteredDate = .now
    }

    @MainActor static let sampleData = [
        Collection(
            id: UUID(),
            title: "Title",
            ratings: "Unrated",
            genre: "Other",
            releaseDate: .now,
            purchaseDate: .now,
            locations: "Other",
            enteredDate: .now
        )
    ]
}
