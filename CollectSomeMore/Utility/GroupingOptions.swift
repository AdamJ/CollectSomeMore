//
//  GroupingOptions.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 6/6/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import Foundation

enum GameGroupingOption: String, CaseIterable, Identifiable {
    case gameTitle // This will be the default, grouped by first letter
    case brand
    case system
    case location
    case genre // Assuming GameCollection has a 'genre' property

    var id: String { self.rawValue }

    var displayName: String {
        switch self {
        case .gameTitle: return "Title"
        case .brand: return "Brand"
        case .system: return "Console"
        case .location: return "Location"
        case .genre: return "Genre"
        }
    }
}

enum MovieGroupingOption: String, CaseIterable, Identifiable {
    case movieTitle // This will be the default, grouped by first letter
    case genre
    case studio
    case rating
    case location // Assuming GameCollection has a 'genre' property

    var id: String { self.rawValue }

    var displayName: String {
        switch self {
            case .movieTitle: return "Title"
            case .genre: return "Genre"
            case .studio: return "Studio"
            case .rating: return "Rating"
            case .location: return "Location"
        }
    }
}
