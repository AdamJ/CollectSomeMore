//
//  ContentView.swift
//  CollectSomeMore
//
//  Created by Adam Jolicoeur on 6/7/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Movie.title) private var movies: [Movie]

    @State private var newMovie: Movie?
    @State private var searchText = ""

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            MovieList(movie: MovieData.shared.movie)
                .tabItem {
                    Label("Movies", systemImage: "popcorn")
                }
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview("Data List") {
    ContentView()
        .navigationTitle("Movies")
        .navigationBarTitleDisplayMode(.automatic)
        .modelContainer(MovieData.shared.modelContainer)
}

#Preview("Empty List") {
    ContentView()
        .modelContainer(for: Movie.self, inMemory: true)
}
