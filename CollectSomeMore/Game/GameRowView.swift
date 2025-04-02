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
        HStack(spacing: Constants.SpacerNone) {
            HStack(spacing: Constants.SpacerNone) {
                VStack(alignment: .leading, spacing: Constants.SpacerNone) {
                    Text(gameCollection.gameTitle ?? "")
                        .foregroundColor(.text)
                        .font(.custom("Oswald-SemiBold", size: 16))
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    Text(gameCollection.system ?? "")
                        .foregroundColor(.text)
                        .font(.custom("Oswald-Regular", size: 14))
                        .fontWeight(.regular)
                        .lineLimit(1)
                }
                .padding(.trailing, Constants.SpacerMedium)
                if gameCollection.console == "PlayStation" {
                    Label("", systemImage: "playstation.logo")
                } else if gameCollection.console == "Xbox" {
                    Label("", systemImage: "xbox.logo")
                } else if gameCollection.console == "Nintendo" {
                    Label("", systemImage: "switch.2")
                } else if gameCollection.console == "PC" {
                    Label("", systemImage: "pc")
                } else if gameCollection.console == "Apple" {
                    Label("", systemImage: "formfitting.gamecontroller")
                } else if gameCollection.console == "Android" {
                    Label("", image: "android")
                        .imageScale(.small)
                        .foregroundStyle(.gray06)
                } else {
                    ConsoleIconView(console: gameCollection.console ?? "")
                        .font(.custom("Oswald-Regular", size: 14))
                        .foregroundColor(.gray06)
                        .padding(.trailing, Constants.SpacerSmall)
                }
                HStack {
                    if UserInterfaceSizeClass.regular == horizontalSizeClass {
                        HStack {
                            Text(gameCollection.console ?? "")
                                .font(.custom("Oswald-ExtraLight", size: 14))
                                .foregroundStyle(.gray06)
                        }
                        HStack {
                            GameLocationIconView(locations: gameCollection.locations ?? "")
                                .foregroundStyle(.gray06)
                        }
                    } else {
                        GameLocationIconView(locations: gameCollection.locations ?? "")
                            .foregroundStyle(.gray06)
                    }
                }
            }
        }
    }
}

#Preview("Content View") {
    let sampleGame = GameCollection(
            id: UUID(),
            collectionState: "Owned",
            gameTitle: "Halo: Infinite",
            console: "XBox",
            system: "Series S/X",
            genre: "Action",
            purchaseDate: Date(),
            locations: "Home",
            notes: "A great game!",
            enteredDate: Date()
        )
        return GameRowView(gameCollection: sampleGame)
            .modelContainer(for: [GameCollection.self])
}
