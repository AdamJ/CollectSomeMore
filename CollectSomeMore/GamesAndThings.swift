//
//  Gamesandthings.swift
//  Games and Things - tracking your collections across gaming genres.
//
//  Created by Adam Jolicoeur on 6/7/24.
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
//    var gameConsole: String
    var ratings: String
    
    init(id: UUID = UUID(), title: String, releaseDate: Date, purchaseDate: Date, genre: String, ratings: String) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.purchaseDate = purchaseDate
        self.genre = genre
//        self.gameConsole = gameConsole
        self.ratings = ratings
    }
    
    @MainActor static let sampleData = [
        Collection(id: UUID(), title: "Deadpool",
            releaseDate: Date(timeIntervalSinceReferenceDate: -402_00_00),
            purchaseDate: Date(timeIntervalSinceNow: -5_000_000),
            genre: "Superhero",
            ratings: "R"
        )
    ]
}
