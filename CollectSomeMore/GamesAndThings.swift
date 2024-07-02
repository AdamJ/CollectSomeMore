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
    var title: String
    var releaseDate: Date
    var purchaseDate: Date
    
    init(title: String, releaseDate: Date, purchaseDate: Date) {
        self.title = title
        self.releaseDate = releaseDate
        self.purchaseDate = purchaseDate
    }
    
    static let sampleData = [
        Movie(title: "Amusing Space Traveler 3",
              releaseDate: Date(timeIntervalSinceReferenceDate: -402_00_00),
              purchaseDate: Date(timeIntervalSinceNow: -5_000_000)),
        Movie(title: "Difficult Cat",
              releaseDate: Date(timeIntervalSinceReferenceDate: -20_000_000),
              purchaseDate: Date(timeIntervalSinceNow: -5_000_000))
    ]
}
