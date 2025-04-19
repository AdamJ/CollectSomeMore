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
    @Environment(\.modelContext) private var modelContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    var body: some View {
        HStack(spacing: Sizing.SpacerNone) {
            VStack(alignment: .leading, spacing: Sizing.SpacerNone) {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    Text(gameCollection.gameTitle ?? "")
                        .foregroundStyle(Color.onSurface)
                        .bodyBoldStyle()
                        .lineLimit(1)
                    Text(gameCollection.system ?? "")
                        .foregroundStyle(Color.onSurfaceVariant)
                        .captionStyle()
                        .lineLimit(1)
                } else {
                    Text(gameCollection.gameTitle ?? "")
                        .foregroundStyle(Color.onSurface)
                        .bodyBoldStyle()
                        .lineLimit(1)
                }
            }
            Spacer()
//            if gameCollection.rating == nil {
//                
//            } else {
//                Text(gameCollection.rating  ?? "")
////                    .padding(.top, Sizing.SpacerSmall)
////                    .padding(.trailing, Sizing.SpacerSmall)
////                    .padding(.bottom, Sizing.SpacerSmall)
////                    .padding(.leading, Sizing.SpacerSmall)
////                    .background(Colors.onSurface)
//                    .foregroundColor(Colors.onSurfaceVariant)
//                    .captionStyle()
////                    .clipShape(.circle)
//                    .padding(.horizontal, Sizing.SpacerSmall)
//            }
            if gameCollection.brand == "PlayStation" {
                Image("playstation")
                    .padding(.top, Sizing.SpacerXSmall)
                    .padding(.trailing, Sizing.SpacerXSmall)
                    .padding(.bottom, Sizing.SpacerXSmall)
                    .padding(.leading, Sizing.SpacerXSmall)
                    .foregroundStyle(Color.blue)
            } else if gameCollection.brand == "Xbox" {
                Image("xbox")
                    .padding(.top, Sizing.SpacerXSmall)
                    .padding(.trailing, Sizing.SpacerXSmall)
                    .padding(.bottom, Sizing.SpacerXSmall)
                    .padding(.leading, Sizing.SpacerXSmall)
                    .foregroundStyle(Color.green)
            } else if gameCollection.brand == "Nintendo" {
                Image("nintendo-switch")
                    .padding(.top, Sizing.SpacerXSmall)
                    .padding(.trailing, Sizing.SpacerXSmall)
                    .padding(.bottom, Sizing.SpacerXSmall)
                    .padding(.leading, Sizing.SpacerXSmall)
                    .foregroundStyle(Color.red)
            } else if gameCollection.brand == "PC" {
                Image("steam")
                    .padding(.top, Sizing.SpacerXSmall)
                    .padding(.trailing, Sizing.SpacerXSmall)
                    .padding(.bottom, Sizing.SpacerXSmall)
                    .padding(.leading, Sizing.SpacerXSmall)
                    .foregroundStyle(Color.gray07)
            } else if gameCollection.brand == "Apple" {
                Image("apple")
                    .padding(.top, Sizing.SpacerXSmall)
                    .padding(.trailing, Sizing.SpacerXSmall)
                    .padding(.bottom, Sizing.SpacerXSmall)
                    .padding(.leading, Sizing.SpacerXSmall)
                    .foregroundStyle(Color.gray07)
            } else if gameCollection.brand == "Android" {
                Image("android")
                    .padding(.top, Sizing.SpacerXSmall)
                    .padding(.trailing, Sizing.SpacerXSmall)
                    .padding(.bottom, Sizing.SpacerXSmall)
                    .padding(.leading, Sizing.SpacerXSmall)
                    .foregroundStyle(Color.backgroundGreen)
            } else if gameCollection.brand == "Meta" {
                Image("headset-vr")
                    .padding(.top, Sizing.SpacerXSmall)
                    .padding(.trailing, Sizing.SpacerXSmall)
                    .padding(.bottom, Sizing.SpacerXSmall)
                    .padding(.leading, Sizing.SpacerXSmall)
                    .foregroundStyle(Color.backgroundBlue)
            } else {
                BrandIconView(brand: gameCollection.brand ?? "")
                    .padding(.top, Sizing.SpacerXSmall)
                    .padding(.trailing, Sizing.SpacerXSmall)
                    .padding(.bottom, Sizing.SpacerXSmall)
                    .padding(.leading, Sizing.SpacerXSmall)
                    .foregroundStyle(Color.onSurfaceVariant)
                    .padding(.trailing, Sizing.SpacerNone)
            }
        }
    }
}

#Preview("Game Row View") {
    let sampleGame = GameCollection(
            id: UUID(),
            collectionState: "Owned",
            gameTitle: "Halo: Infinite",
            brand: "Xbox",
            system: "Series S/X",
            rating: "M",
            genre: "Action",
            purchaseDate: Date(),
            locations: "Local",
            notes: "It is nice to have notes for the collection, just in case there are fields that do not cover certain bits of information.",
            enteredDate: Date()
        )
        return GameRowView(gameCollection: sampleGame)
            .modelContainer(for: [GameCollection.self])
}
