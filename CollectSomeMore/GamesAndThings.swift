//
//  Gamesandthings.swift
//  Games and Things - tracking your collections across gaming genres.
//
//  Created by Adam Jolicoeur on 6/7/24.
//

import Foundation
import SwiftData

@Model
final class Movie {
    var id: UUID
    var title: String
    var releaseDate: Date
    var purchaseDate: Date
    var genre: String
    var imageData: Data?
    
    init(id: UUID = UUID(), title: String, releaseDate: Date, purchaseDate: Date, genre: String, imageData: Data? = nil) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.purchaseDate = purchaseDate
        self.genre = genre
        self.imageData = imageData
    }
    
    static let sampleData = [
        Movie(id: UUID(), title: "Deadpool",
              releaseDate: Date(timeIntervalSinceReferenceDate: -402_00_00),
              purchaseDate: Date(timeIntervalSinceNow: -5_000_000),
              genre: "Superhero"),
        Movie(id: UUID(), title: "Deadpool & Wolverine",
              releaseDate: Date(timeIntervalSinceReferenceDate: -20_000_000),
              purchaseDate: Date(timeIntervalSinceNow: -5_000_000),
              genre: "Comedy")
    ]
}
