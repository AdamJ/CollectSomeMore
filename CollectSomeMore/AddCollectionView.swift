//
//  AddCollectionView.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 4/1/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI
import SwiftData

struct AddCollectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Query(sort: \MovieCollection.movieTitle) private var collections: [MovieCollection]
    @Query private var games: [GameCollection]
    @State private var newMovieCollection: MovieCollection?
    @State private var newGameCollection: GameCollection?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: Sizing.SpacerMedium) {
                HStack(alignment: .center) {
                    Text("Add Items to Your Collection")
                        .titleStyle()
                }
                .padding(.horizontal, Sizing.SpacerNone)
                .padding(.vertical, Sizing.SpacerNone)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: Sizing.SpacerMedium) { // Column
                    VStack(alignment: .leading, spacing: Sizing.SpacerXSmall) { // List Item
                        VStack(alignment: .leading) {
                            Button(action: addMovieCollection) {
                                Label("Add Movie", systemImage: "popcorn")
                            }
                            .buttonStyle(PrimaryButtonStyle())
                        }
                    }
                    .padding(0)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    VStack(alignment: .leading, spacing: Sizing.SpacerXSmall) { // List Item
                        VStack(alignment: .leading) {
                            Button(action: addGameCollection) {
                                Label("Add Game", systemImage: "gamecontroller")
                            }
                            .buttonStyle(PrimaryButtonStyle())
                        }
                    }
                    .padding(0)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                Spacer()
                .padding(.horizontal, Sizing.SpacerMedium)
                .padding(.vertical, Sizing.SpacerNone)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .padding()
//            .background(Gradient(colors: darkBottom))
            .background(Colors.surfaceLevel)
        }
        .sheet(item: $newMovieCollection) { collection in
            NavigationStack {
                VStack {
                    MovieDetail(movieCollection: collection, isNew: true)
                }
            }
            .interactiveDismissDisabled()
        }
        .sheet(item: $newGameCollection) { collection in
            NavigationStack {
                VStack {
                    GameDetailView(gameCollection: collection, isNew: true)
                }
            }
            .interactiveDismissDisabled()
        }
    }
    private func addMovieCollection() {
        withAnimation {
            let newItem = MovieCollection(id: UUID(), movieTitle: "", ratings: "Unrated", genre: "Other", studio: "None", platform: "None", releaseDate: .now, purchaseDate: .now, locations: "None", enteredDate: .now)
            newMovieCollection = newItem
        }
    }
    private func addGameCollection() {
        withAnimation {
            let newItem = GameCollection(id: UUID(), collectionState: "Owned", gameTitle: "", brand: "None", system: "None", rating: "Unknown", genre: "Other", purchaseDate: .now, locations: "None", notes: "", enteredDate: .now)
            newGameCollection = newItem
        }
    }
}

#Preview("Add Collection View") {
    AddCollectionView()
}
