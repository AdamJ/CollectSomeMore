//
//  GameCollection.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/26/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import Foundation
import SwiftData

@Model
class GameCollection {
    @Attribute var id = UUID()
    var collectionState: String?
    var gameTitle: String?
    var brand: String?
    var system: String?
    var rating: String?
    var genre: String?
    var purchaseDate: Date?
    var locations: String?
    var notes: String = ""
    var enteredDate: Date?

    init(id: UUID = UUID(), collectionState: String? = nil, gameTitle: String? = nil, brand: String? = nil, system: String? = nil, rating: String? = nil, genre: String? = nil, purchaseDate: Date? = nil, locations: String? = nil, notes: String? = nil, enteredDate: Date? = nil) {
        self.id = id
        self.collectionState = collectionState
        self.gameTitle = gameTitle
        self.brand = brand
        self.system = system
        self.rating = rating
        self.genre = genre
        self.purchaseDate = purchaseDate
        self.locations = locations
        self.notes = notes ?? ""
        self.enteredDate = enteredDate ?? Date()
    }

    @MainActor static let sampleGameCollectionData = [
        GameCollection(
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
            enteredDate: Date()
        )
    ]
}
