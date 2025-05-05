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
            if gameCollection.brand == "PlayStation" {
                Image("playstation")
                    .padding(.top, Sizing.SpacerXSmall)
                    .padding(.trailing, Sizing.SpacerXSmall)
                    .padding(.bottom, Sizing.SpacerXSmall)
                    .padding(.leading, Sizing.SpacerXSmall)
                    .foregroundStyle(Colors.playstationBlue)
            } else if gameCollection.brand == "Xbox" {
                Image("xbox")
                    .padding(.top, Sizing.SpacerXSmall)
                    .padding(.trailing, Sizing.SpacerXSmall)
                    .padding(.bottom, Sizing.SpacerXSmall)
                    .padding(.leading, Sizing.SpacerXSmall)
                    .foregroundStyle(Colors.xboxGreen)
            } else if gameCollection.brand == "Nintendo" {
                Image("nintendo-switch")
                    .padding(.top, Sizing.SpacerXSmall)
                    .padding(.trailing, Sizing.SpacerXSmall)
                    .padding(.bottom, Sizing.SpacerXSmall)
                    .padding(.leading, Sizing.SpacerXSmall)
                    .foregroundStyle(Colors.nintendoRed)
            } else if gameCollection.brand == "PC" {
                Image("steam")
                    .padding(.top, Sizing.SpacerXSmall)
                    .padding(.trailing, Sizing.SpacerXSmall)
                    .padding(.bottom, Sizing.SpacerXSmall)
                    .padding(.leading, Sizing.SpacerXSmall)
                    .foregroundStyle(Colors.steamBlack)
            } else if gameCollection.brand == "AppStore" {
                Image("apple-fill")
                    .padding(.top, Sizing.SpacerXSmall)
                    .padding(.trailing, Sizing.SpacerXSmall)
                    .padding(.bottom, Sizing.SpacerXSmall)
                    .padding(.leading, Sizing.SpacerXSmall)
                    .foregroundStyle(Colors.appleSlate)
            } else if gameCollection.brand == "Android" {
                Image("android")
                    .padding(.top, Sizing.SpacerXSmall)
                    .padding(.trailing, Sizing.SpacerXSmall)
                    .padding(.bottom, Sizing.SpacerXSmall)
                    .padding(.leading, Sizing.SpacerXSmall)
                    .foregroundStyle(Colors.androidGreen)
            } else if gameCollection.brand == "Meta" {
                Image("headset-vr")
                    .padding(.top, Sizing.SpacerXSmall)
                    .padding(.trailing, Sizing.SpacerXSmall)
                    .padding(.bottom, Sizing.SpacerXSmall)
                    .padding(.leading, Sizing.SpacerXSmall)
                    .foregroundStyle(Colors.metaBlue)
            } else if gameCollection.brand == "Sega" {
                Image("sega")
                    .padding(.top, Sizing.SpacerXSmall)
                    .padding(.trailing, Sizing.SpacerXSmall)
                    .padding(.bottom, Sizing.SpacerXSmall)
                    .padding(.leading, Sizing.SpacerXSmall)
                    .foregroundStyle(Color.onSurface)
            } else {
                BrandIconView(brand: gameCollection.brand ?? "")
                    .padding(.top, Sizing.SpacerXSmall)
                    .padding(.trailing, Sizing.SpacerXSmall)
                    .padding(.bottom, Sizing.SpacerXSmall)
                    .padding(.leading, Sizing.SpacerXSmall)
                    .foregroundStyle(Color.onSurfaceVariant)
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
