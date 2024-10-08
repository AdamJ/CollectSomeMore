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
            Tab("Home", systemImage: "house") {
                Text("Start here!")
            }
            TabSection("Video") {
                Tab("Movies", systemImage: "popcorn") {
                    MovieList(movie: MovieData.shared.movie)
                }

                Tab("TV Shows", systemImage: "tv") {
                    Text("List of tv shows")
                }
            }

            TabSection("Audio") {
                Tab("Podcasts", systemImage: "mic") {
                    Text("Favorite podcasts")
                }
                
                Tab("Music", systemImage: "music.note.list") {
                    Text("Favorite music things")
                }
            }

            Tab("Search", systemImage: "magnifyingglass") {
                SearchView()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview("Data List") {
    ContentView()
        .navigationTitle("Movies")
        .navigationBarTitleDisplayMode(.inline)
        .modelContainer(MovieData.shared.modelContainer)
}

#Preview("Empty List") {
    ContentView()
        .modelContainer(for: Movie.self, inMemory: true)
}
