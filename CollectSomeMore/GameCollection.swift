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
    var console: String?
    var genre: String?
    var purchaseDate: Date?
    var locations: String?
    var notes: String?
    var enteredDate: Date?

    init(id: UUID = UUID(), collectionState: String? = nil, gameTitle: String? = nil, console: String? = nil, genre: String? = nil, purchaseDate: Date? = nil, locations: String? = nil, notes: String? = nil, enteredDate: Date? = nil) {
        self.id = id
        self.collectionState = collectionState
        self.gameTitle = gameTitle
        self.console = console
        self.genre = genre
        self.purchaseDate = purchaseDate
        self.locations = locations
        self.notes = notes
        self.enteredDate = enteredDate ?? Date()
    }

    @MainActor static let sampleGameCollectionData = [
        GameCollection(
            id: UUID(),
            collectionState: "Physical",
            gameTitle: "Title",
            console: "None",
            genre: "Other",
            purchaseDate: .now,
            locations: "Other",
            notes: nil,
            enteredDate: .now
        )
    ]
}
