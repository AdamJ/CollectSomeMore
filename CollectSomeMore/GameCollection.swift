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
    var isPlayed: Bool = false

    init(id: UUID = UUID(), collectionState: String? = nil, gameTitle: String? = nil, brand: String? = nil, system: String? = nil, rating: String? = nil, genre: String? = nil, purchaseDate: Date? = nil, locations: String? = nil, notes: String? = nil, enteredDate: Date? = nil, isPlayed: Bool = false) {
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
        self.isPlayed = isPlayed
    }
    
    @MainActor static var sampleGameCollectionData: [GameCollection] {
        [
            GameCollection(
                collectionState: "Digital",
                gameTitle: "Halo: Infinite",
                brand: "Xbox",
                system: "Xbox Series S/X",
                rating: "M",
                genre: "Action",
                purchaseDate: Calendar.current.date(byAdding: .month, value: -1, to: Date()), // Example past date
                locations: "Physical",
                notes: "Need to try this out with friends.",
                isPlayed: true // Example initial state
            ),
            GameCollection(
                collectionState: "Wishlist",
                gameTitle: "The Legend of Zelda: Tears of the Kingdom",
                brand: "Nintendo",
                system: "Switch",
                rating: "E10+",
                genre: "Action-Adventure",
                locations: "None",
                notes: "Heard great things!",
                isPlayed: false // Example initial state
            ),
            GameCollection(
                collectionState: "Owned",
                gameTitle: "Cyberpunk 2077",
                brand: "PC",
                system: "GOG",
                rating: "AO",
                genre: "RPG",
                purchaseDate: Calendar.current.date(byAdding: .year, value: -2, to: Date()), // Example past date
                locations: "Digital",
                notes: "Finished main story.",
                isPlayed: true // Example initial state
            )
        ]
    }
}
