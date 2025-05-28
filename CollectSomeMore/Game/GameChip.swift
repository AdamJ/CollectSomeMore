//
//  GameChip.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 5/16/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI
import SwiftData

struct GameChip: View {
    @Bindable var gameCollection: GameCollection

    let description: String
    let system = GameSystems.systems
    let rating = GameRatings.ratings

    var body: some View {
        VStack(alignment: .leading, spacing: Sizing.SpacerSmall) {
            VStack(alignment: .leading, spacing: Sizing.SpacerNone) { // Header
                HStack(alignment: .top, spacing: Sizing.SpacerSmall) { // Assistive Chips
                    // MARK: - Total Movie Count
                    ChipItem(
                        value: gameCollection.rating ?? "No rating"
                    )
                    
                    ChipItem(
                        value: gameCollection.system ?? "No system"
                    )
                }
                .padding(0)
                .frame(maxWidth: .infinity, alignment: .bottomLeading)
            }
            .padding(Sizing.SpacerMedium)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Colors.secondaryContainer)
        }
        .padding(0)
    }
}

struct ChipItem: View {
    let value: String

    var body: some View {
        HStack(alignment: .center, spacing: Sizing.SpacerNone) { // Chip
            HStack(alignment: .center, spacing: Sizing.SpacerSmall) { // State Layer
                Text(value)
                    .padding(.top, Sizing.SpacerXSmall)
                    .padding(.trailing, Sizing.SpacerMedium)
                    .padding(.bottom, Sizing.SpacerXSmall)
                    .padding(.leading, Sizing.SpacerMedium)
                    .background(Colors.accent)
                    .foregroundColor(Colors.inverseOnSurface)
                    .bodyBoldStyle()
                    .multilineTextAlignment(.center)
            }
            .padding(.leading, Sizing.SpacerSmall)
            .padding(.trailing, Sizing.SpacerSmall)
            .padding(.vertical, Sizing.SpacerSmall)
            .frame(height: 32)
        }
        .padding(0)
        .background(Colors.accent)
        .cornerRadius(16)
    }
}
