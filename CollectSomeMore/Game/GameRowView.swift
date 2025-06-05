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
            if gameCollection.isPlayed == true {
                Image(systemName: "checkmark.seal.fill")
                    .padding(.top, Sizing.SpacerXSmall)
                    .padding(.trailing, Sizing.SpacerXSmall)
                    .padding(.bottom, Sizing.SpacerXSmall)
                    .padding(.leading, Sizing.SpacerXSmall)
                    .foregroundStyle(Color.green)
            } else {
                Image(systemName: "seal")
                    .padding(.top, Sizing.SpacerXSmall)
                    .padding(.trailing, Sizing.SpacerXSmall)
                    .padding(.bottom, Sizing.SpacerXSmall)
                    .padding(.leading, Sizing.SpacerXSmall)
                    .foregroundStyle(Color.orange)
            }
            VStack(alignment: .leading, spacing: Sizing.SpacerXSmall) {
//                if UIDevice.current.userInterfaceIdiom == .pad {
                Text(gameCollection.gameTitle ?? "")
                    .foregroundStyle(Color.onSurface)
                    .bodyBoldStyle()
                    .lineLimit(1)
                HStack(spacing: Sizing.SpacerMedium) {
                    if gameCollection.system == "None" {
                        Text("No system selected")
                            .foregroundStyle(Color.onSurfaceVariant)
                            .captionStyle()
                            .lineLimit(1)
                    } else {
                        Text(gameCollection.system ?? "")
                            .foregroundStyle(Color.onSurfaceVariant)
                            .captionStyle()
                            .lineLimit(1)
                    }
                    if gameCollection.rating == "Unrated" {
                    } else {
                        Text(gameCollection.rating ?? "")
                            .foregroundStyle(Color.onSurfaceVariant)
                            .captionStyle()
                            .lineLimit(1)
                    }
                }
            }

            Spacer()
        }
        .padding(.vertical, Sizing.SpacerXSmall)
        .background(Color.clear)
    }
}

#Preview("Game Row View") {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: GameCollection.self, configurations: config)

        // Directly reference the static sample data from GameCollection
        @MainActor func insertSampleData() {
            for game in GameCollection.sampleGameCollectionData { // <-- Reference like this!
                container.mainContext.insert(game)
            }
        }
        insertSampleData()

        return GameListView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create ModelContainer for preview: \(error)")
    }
}
