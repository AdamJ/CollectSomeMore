//
//  GameRowView.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/26/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI
import SwiftData

struct GameRowView: View {
    @Bindable var gameCollection: GameCollection
    @Query private var movies: [MovieCollection]
    @Query private var games: [GameCollection]
    
    var body: some View {
        HStack(spacing: Constants.SpacerNone) {
            Text("Game Row View")
        }
    }
}
