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
            
            Text("Time to add an item to your collection!")
            VStack {
                Button(action: addMovieCollection) {
                    Label("Add Movie", systemImage: "plus.app")
                }
                .buttonStyle(.transparentOutline)
                .tint(.accentColor)
                Button(action: addGameCollection) {
                    Label("Add Game", systemImage: "plus.app")
                }
                .buttonStyle(.transparentOutline)
                .tint(.accentColor)
            }
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
            let newItem = MovieCollection(id: UUID(), movieTitle: "", ratings: "Unrated", genre: "Other", releaseDate: .now, purchaseDate: .now, locations: "None", enteredDate: .now)
            newMovieCollection = newItem
        }
    }
    private func addGameCollection() {
        withAnimation {
            let newItem = GameCollection(id: UUID(), collectionState: "", gameTitle: "", brand: "None", system: "None", genre: "Other", purchaseDate: .now, locations: "None", notes: "", enteredDate: .now)
            newGameCollection = newItem
        }
    }
}
