//
//  MovieList.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 10/8/24.
//

import SwiftUI
import SwiftData

struct MovieList: View {
    @Bindable var movie: Movie
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Movie.title) private var movies: [Movie]

    enum SortOption {
        case title, genre
    }
    
    @State private var newMovie: Movie?
    @State private var selectedItem: Int = 0
    @State private var sortOption: SortOption = .title
    
    let isNew: Bool
    
    init(movie: Movie, isNew: Bool = false) {
        self.movie = movie
        self.isNew = isNew
    }

    var sortedMovies: [Movie] {
        switch sortOption {
            case .title:
                // sort A -> Z
                return movies.sorted { $0.title < $1.title }
            case .genre:
                // sort A -> Z
                return movies.sorted { $0.genre < $1.genre }
            }
        }
    
    var body: some View {
        NavigationStack {
            Picker("Sort By", selection: $sortOption) {
                Text("Title").tag(SortOption.title)
//                Text("Release Date").tag(SortOption.releaseDate)
                Text("Genre").tag(SortOption.genre)
            }.pickerStyle(SegmentedPickerStyle())
            Group {
                if !movies.isEmpty {
                    List {
                        ForEach(sortedMovies) { movie in
                            NavigationLink(destination: MovieDetail(movie: movie)) {
                                MovieRowView(movie: movie)
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .navigationTitle("Movies")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                           EditButton()
                        }
                        ToolbarItemGroup(placement: .primaryAction) {
                            Button(action: addMovie) {
                                Label("Add Movie", systemImage: "plus.app")
                            }
                        }
                    }
                } else {
                    ContentUnavailableView {
                        Label("There are no movies in your collection.", systemImage: "list.and.film")
                        Button("Add a movie", action: addMovie)
                            .buttonStyle(.borderedProminent)
                            .foregroundStyle(.background)
                    }
                }
            }
        }
        .sheet(item: $newMovie) { movie in
            NavigationStack {
                MovieDetail(movie: movie, isNew: true)
            }
            .interactiveDismissDisabled() // prevents users from swiping down to dismiss
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

#Preview("Data List") {
    NavigationStack {
        MovieList(movie: MovieData.shared.movie)
    }
    .navigationTitle("Movies")
    .navigationBarTitleDisplayMode(.inline)
    .modelContainer(MovieData.shared.modelContainer)
}

#Preview("Empty List") {
    NavigationStack {
        MovieList(movie: MovieData.shared.movie)
    }
    .modelContainer(for: Movie.self, inMemory: true)
}
