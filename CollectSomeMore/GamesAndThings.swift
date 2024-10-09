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
//    var figure: String
//    var imageData: Data?
//    var rating: String
//    var location: String
//    var videoFormat: String
    
    init(id: UUID = UUID(), title: String, releaseDate: Date, purchaseDate: Date, genre: String/*, figure: String*/) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.purchaseDate = purchaseDate
        self.genre = genre
//        self.figure = figure
//        self.imageData = imageData
//        self.rating = rating
//        self.location = location
//        self.videoFormat = videoFormat
    }
    
    @MainActor static let sampleData = [
        Movie(id: UUID(), title: "Deadpool",
              releaseDate: Date(timeIntervalSinceReferenceDate: -402_00_00),
              purchaseDate: Date(timeIntervalSinceNow: -5_000_000),
              genre: "Superhero"/*, figure: "Movie"*/)
    ]
}
