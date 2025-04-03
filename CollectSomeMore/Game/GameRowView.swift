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
                        .font(.custom("Oswald-SemiBold", size: 18))
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    Text(gameCollection.system ?? "")
                        .foregroundColor(.secondary)
                        .font(.custom("Oswald-Regular", size: 14))
                        .fontWeight(.regular)
                        .lineLimit(1)
                }
                Spacer()
                if gameCollection.rating == nil {
                    
                } else {
                    Text(gameCollection.rating  ?? "")
                        .fontWeight(.bold)
                        .padding(.top, Constants.SpacerXSmall)
                        .padding(.trailing, Constants.SpacerXSmall)
                        .padding(.bottom, Constants.SpacerXSmall)
                        .padding(.leading, Constants.SpacerXSmall)
                        .background(Color.gray09)
                        .foregroundColor(.gray01)
                        .font(.custom("Oswald-Regular", size: 16))
                        .clipShape(.buttonBorder)
                        .padding(.horizontal, Constants.SpacerMedium)
                }
                if gameCollection.brand == "PlayStation" {
                    Label("", systemImage: "playstation.logo")
                        .foregroundStyle(.gray06)
                        .padding(.trailing, Constants.SpacerNone)
                } else if gameCollection.brand == "Xbox" {
                    Label("", systemImage: "xbox.logo")
                        .foregroundStyle(.gray06)
                        .padding(0)
                } else if gameCollection.brand == "Nintendo" {
                    Label("", systemImage: "switch.2")
                        .foregroundStyle(.gray06)
                        .padding(.trailing, Constants.SpacerNone)
                } else if gameCollection.brand == "PC" {
                    Label("", systemImage: "pc")
                        .foregroundStyle(.gray06)
                        .padding(.trailing, Constants.SpacerNone)
                } else if gameCollection.brand == "Apple" {
                    Label("", systemImage: "formfitting.gamecontroller")
                        .foregroundStyle(.gray06)
                        .padding(.trailing, Constants.SpacerNone)
                } else if gameCollection.brand == "Android" {
                    Label("", image: "android")
                        .imageScale(.small)
                        .foregroundStyle(.gray06)
                        .padding(.trailing, Constants.SpacerNone)
                } else {
                    BrandIconView(brand: gameCollection.brand ?? "")
                        .font(.custom("Oswald-Regular", size: 14))
                        .foregroundColor(.gray06)
                        .padding(.trailing, Constants.SpacerNone)
                }
//                HStack {
//                    if UserInterfaceSizeClass.regular == horizontalSizeClass {
////                        HStack {
////                            Text(gameCollection.system ?? "")
////                                .font(.custom("Oswald-Regular", size: 14))
////                                .foregroundStyle(.gray09)
////                        }
//                        HStack {
//                            GameLocationIconView(locations: gameCollection.locations ?? "")
//                                .foregroundStyle(.gray06)
//                                .padding(0)
//                        }
//                    } else {
//                        GameLocationIconView(locations: gameCollection.locations ?? "")
//                            .foregroundStyle(.gray06)
//                    }
//                }
            }
        }
    }
}

#Preview("Content View") {
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
