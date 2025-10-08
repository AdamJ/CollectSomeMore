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
    var rating: String?
    var genre: String?
    var studio: String?
    var platform: String?
    var service: String?
    var releaseDate: Date?
    var purchaseDate: Date?
    var location: String?
    var enteredDate: Date?
    var notes: String = ""
    var isWatched: Bool = false

    init(id: UUID = UUID(), movieTitle: String? = nil, rating: String? = nil, genre: String? = nil, studio: String? = nil, platform: String? = nil, service: String? = nil, releaseDate: Date? = nil, purchaseDate: Date? = nil, location: String? = nil, enteredDate: Date? = nil, notes: String? = nil, isWatched: Bool = false) {
        self.id = id
        self.movieTitle = movieTitle
        self.rating = rating
        self.genre = genre
        self.studio = studio
        self.platform = platform
        self.service = service
        self.releaseDate = releaseDate
        self.purchaseDate = purchaseDate
        self.location = location
        self.enteredDate = enteredDate ?? Date()
        self.notes = notes ?? ""
        self.isWatched = isWatched
    }

    @MainActor static var sampleMovieCollectionData: [MovieCollection] {
        [
            MovieCollection(
                movieTitle: "Warriors of the Wind",
                rating: "G",
                genre: "Animated",
                studio: "Studio Ghibli",
                platform: "Streaming",
                service: "Disney+",
                releaseDate: .now,
                purchaseDate: .now,
                location: "Physical",
                enteredDate: Calendar.current.date(byAdding: .year, value: -10, to: Date()), // Example past date
                notes: "One of my favorite movies.",
                isWatched: true
            ),
            MovieCollection(
                movieTitle: "Back to the Future: Part 1",
                rating: "PG",
                genre: "Comedy",
                studio: "Universal Pictures",
                platform: "Blu-Ray",
                service: "None",
                releaseDate: Calendar.current.date(byAdding: .year, value: -2, to: Date()), // Example past date
                purchaseDate: Calendar.current.date(byAdding: .year, value: -2, to: Date()), // Example past date
                location: "Physical",
                enteredDate: Calendar.current.date(byAdding: .year, value: -2, to: Date()), // Example past date
                notes: "",
                isWatched: true
            ),
            MovieCollection(
                movieTitle: "Ginger Snaps",
                rating: "NR",
                genre: "Horror",
                studio: "Indie",
                platform: "Streaming",
                service: "Prime Video",
                releaseDate: Calendar.current.date(byAdding: .year, value: -12, to: Date()), // Example past date
                purchaseDate: .now,
                location: "None",
                enteredDate: .now,
                notes: "",
                isWatched: false
            ),
            MovieCollection(
                movieTitle: "Lord of the Rings: Fellowship of the Ring",
                rating: "PG-13",
                genre: "Fantasy",
                studio: "Warner Bros",
                platform: "Blu-Ray",
                service: "None",
                releaseDate: Calendar.current.date(byAdding: .year, value: -12, to: Date()), // Example past date
                purchaseDate: .now,
                location: "Physical",
                enteredDate: .now,
                notes: "",
                isWatched: true
            ),
            MovieCollection(
                movieTitle: "House on Haunted Hill",
                rating: "R",
                genre: "Horror",
                studio: "Indie",
                platform: "DVD",
                service: "None",
                releaseDate: Calendar.current.date(byAdding: .year, value: -12, to: Date()), // Example past date
                purchaseDate: .now,
                location: "Physical",
                enteredDate: .now,
                notes: "",
                isWatched: true
            )
        ]
    }
}
