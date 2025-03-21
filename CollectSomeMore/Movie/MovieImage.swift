//
//  MovieImage.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/21/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftData
import SwiftUI

@Model
class MovieImage { // Rename to your model name if needed
    var title: String
    var imageData: Data? // Store image as Data
    // ... other properties

    init(title: String, imageData: Data? = nil) {
        self.title = title
        self.imageData = imageData
    }
}
