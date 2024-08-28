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
        NavigationSplitView {
            Group {
                if !movies.isEmpty {
                    List {
                        ForEach(filteredMovies) { movie in
                            NavigationLink {
                                MovieDetail(movie: movie)
                            } label: {
                                Text(movie.title)
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .navigationTitle("Movies")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            EditButton()
                        }
                        ToolbarItem {
                            Button(action: addMovie) {
                                Label("Add Movie", systemImage: "plus.app")
                            }
                        }
                    }
                    .searchable(text: $searchText)
                } else {
                    ContentUnavailableView {
                        Label("There are no movies in your collection.", systemImage: "list.and.film")
                        Button("Add a movie", action: addMovie)
                    }
                    .navigationTitle("Movies")
                }
            }
            .sheet(item: $newMovie) { movie in
                NavigationStack {
                    MovieDetail(movie: movie, isNew: true)
                }
                .interactiveDismissDisabled() // prevents users from swiping down to dismiss
            }
        } detail: {
            Text("Select a movie")
                .navigationTitle("Movies")
        }
    }
    
    private var filteredMovies: [Movie] {
        if searchText.isEmpty {
            return movies
        } else {
            return movies.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }

    private func addMovie() {
        withAnimation {
            let newItem = Movie(id: UUID(), title: "", releaseDate: .now, purchaseDate: Date(timeIntervalSinceNow: -5_000_000), genre: "Action")
            modelContext.insert(newItem)
            newMovie = newItem
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(movies[index])
            }
        }
    }
}

#Preview("List view") {
    ContentView()
        .modelContainer(MovieData.shared.modelContainer)
}

#Preview("Empty List") {
    ContentView()
        .modelContainer(for: Movie.self, inMemory: true)
}
