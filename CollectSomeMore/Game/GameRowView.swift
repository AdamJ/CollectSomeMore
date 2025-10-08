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
        HStack {
            VStack(alignment: .leading, spacing: Sizing.SpacerXSmall) {
                Text(gameCollection.gameTitle ?? "")
                    .foregroundStyle(Color.onSurface)
                    .bodyBoldStyle()
                    .lineLimit(1)
                HStack(spacing: Sizing.SpacerMedium) {
                    if gameCollection.isPlayed == true {
                        Image(systemName: "checkmark.seal.fill")
                            .padding(.top, Sizing.SpacerXSmall)
                            .padding(.trailing, Sizing.SpacerXSmall)
                            .padding(.bottom, Sizing.SpacerXSmall)
                            .padding(.leading, Sizing.SpacerXSmall)
                            .foregroundStyle(Colors.blue)
                            .frame(width: 16, height: 16)
                    } else {
                        Image(systemName: "seal.fill")
                            .padding(.top, Sizing.SpacerXSmall)
                            .padding(.trailing, Sizing.SpacerXSmall)
                            .padding(.bottom, Sizing.SpacerXSmall)
                            .padding(.leading, Sizing.SpacerXSmall)
                            .foregroundStyle(Colors.gray)
                            .frame(width: 16, height: 16)
                    }
                    if gameCollection.rating == nil {
                        
                    } else {
                        Text(gameCollection.rating ?? "")
                            .foregroundStyle(.onSurfaceVariant)
                            .captionStyle()
                    }

                    if gameCollection.system == "None" {
                    } else {
                        Text(gameCollection.system ?? "")
                            .foregroundStyle(Color.onSurfaceVariant)
                            .captionStyle()
                            .lineLimit(1)
                    }
                }
            }
            .padding(.vertical, Sizing.SpacerSmall)
            
            Spacer()
        }
//        .background(Color.clear)
    }
}

//#Preview("Game Row") {
//    let sampleGame = GameCollection(
//        id: UUID(),
//        collectionState: "Owned",
//        gameTitle: "Halo: Infinite",
//        brand: "Xbox",
//        system: "Xbox Series S/X",
//        rating: "M",
//        genre: "Action",
//        purchaseDate: Date(),
//        location: "Cabinet",
//        notes: "Need to try this out with friends.",
//        enteredDate: Date(),
//        isPlayed: false,
//        entityName: "Game",
//        console: "Xbox"
//    )
//    return GameRowView(gameCollection: sampleGame)
//        .modelContainer(for: [GameCollection.self])
//}
