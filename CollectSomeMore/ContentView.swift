//
//  ContentView.swift
//  CollectSomeMore
//
//  Created by Adam Jolicoeur on 6/7/24.
//

import SwiftUI
import SwiftData

struct AddItemsView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        AddGameView()
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var newMovieCollection: MovieCollection?
    @State private var newGameCollection: GameCollection?
    @State private var showingAddSheet = false

    var body: some View {
        TabView() {
            Tab("Home", image: "house") {
                HomeView()
            }
            .accessibilityHint(Text("Go to the home screen"))

            Tab("Games", systemImage: "gamecontroller.fill") {
                GameListView()
            }
            .accessibilityHint(Text("View your collection of games"))

            Tab("Add", systemImage: "plus.square.on.square") {
                AddCollectionView()
            }
            .accessibilityHint(Text("Add a new item to a collection"))
            
            Tab("Movies", systemImage: "film.stack") {
                MovieList()
            }
            .accessibilityHint(Text("View your collection of movies"))

            TabSection("Info") {
                Tab("About", systemImage: "info.circle") {
                    AboutView()
                }
                .accessibilityHint(Text("Learn more about the app"))
                .tabPlacement(.sidebarOnly)
                
                Tab("Search All Collections", systemImage: "rectangle.and.text.magnifyingglass") {
                    SearchView()
                }
                .accessibilityHint(Text("Search through your games and movies"))
                .tabPlacement(.sidebarOnly)
            }
            .tabPlacement(.sidebarOnly)
        }
        .tabViewStyle(.sidebarAdaptable)
        .environment(\.font, .oswald(size: 16))
    }
    
    private func addMovieCollection() {
        withAnimation {
            let newItem = MovieCollection(id: UUID(), movieTitle: "", ratings: "Unrated", genre: "Other", studio: "Unknown", platform: "Unknown", releaseDate: .now, purchaseDate: .now, locations: "None", enteredDate: .now)
            newMovieCollection = newItem
        }
    }
    private func addGameCollection() {
        withAnimation {
            let newItem = GameCollection(id: UUID(), collectionState: "", gameTitle: "", brand: "None", system: "None", rating: "M", genre: "Other", purchaseDate: .now, locations: "None", notes: "", enteredDate: .now)
            newGameCollection = newItem
        }
    }
}

#Preview("Content View") {
    ContentView()
        .modelContainer(for: [GameCollection.self, MovieCollection.self])
//        .background(Gradient(colors: darkBottom))
}
