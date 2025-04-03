//
//  Search.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 10/8/24.
//
import SwiftUI
import SwiftData

protocol SearchableItem: Identifiable {
    var title: String { get }
    var type: SearchResultType { get }
}
enum SearchResultType {
    case movie
    case game
}
extension MovieCollection: SearchableItem {
    var title: String { movieTitle ?? "" }
    var type: SearchResultType { .movie }
}
extension GameCollection: SearchableItem {
    var title: String { gameTitle ?? "" }
    var type: SearchResultType { .game }
}
struct SearchView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MovieCollection.movieTitle) private var collections: [MovieCollection]
    @Query(sort: \GameCollection.gameTitle) private var games: [GameCollection]
    @State private var searchText = ""
    @State private var newMovieCollection: MovieCollection?
    @State private var newGameCollection: GameCollection?
    
    private var filteredItems: [any SearchableItem] {
        if searchText.isEmpty {
            return []
        } else {
            let filteredMovies = collections.filter {
                $0.movieTitle!.localizedCaseInsensitiveContains(searchText)
            }
            let filteredGames = games.filter {
                $0.gameTitle!.localizedCaseInsensitiveContains(searchText)
            }
            return (filteredMovies + filteredGames).sorted { $0.title < $1.title }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if !searchText.isEmpty {
                    List {
                        ForEach(filteredItems.indices, id: \.self) { index in
                            let item = filteredItems[index]
                            NavigationLink {
                                switch item.type {
                                case .movie:
                                    if let movie = item as? MovieCollection {
                                        MovieDetail(movieCollection: movie)
                                    }
                                case .game:
                                    if let game = item as? GameCollection {
                                        GameDetailView(gameCollection: game)
                                    }
                                }
                            }
                            label: {
                                Text(item.title).lineLimit(1)
                                    .font(.custom("Oswald-Regular", size: 14))
                            }
                            .listRowBackground(Color.gray01)
                        }
                    }
                    .padding(.horizontal, Constants.SpacerNone)
                    .padding(.vertical, Constants.SpacerNone)
                    .scrollContentBackground(.hidden) // Hides the background content of the scrollable area
                    .navigationTitle("Search")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItemGroup(placement: .primaryAction) {
                            Menu {
                                Button("Add Movie", action: addGameCollection)
                                Button("Add Game", action: addMovieCollection)
                            } label: {
                                Label("Add", systemImage: "plus.square")
                                    .labelStyle(.titleAndIcon)
                            }
                        }
                    }
                } else {
                    ContentUnavailableView {
                        Label("Search your collections", systemImage: "magnifyingglass")
                            .font(.custom("Oswald-SemiBold", size: 24))
                        Text("by title")
                            .font(.custom("Oswald-Regular", size: 14))
                            .foregroundStyle(.secondary)
                    }
                    .navigationTitle("Search")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItemGroup(placement: .primaryAction) {
                            Menu {
                                Button("Add Game", action: addGameCollection)
                                Button("Add Movie", action: addMovieCollection)
                            } label: {
                                Label("Add", systemImage: "plus.square")
                                    .labelStyle(.titleAndIcon)
                            }
                        }
                    }
                }
            }
            .background(Gradient(colors: darkBottom)) // Default background color for all pages
        }
        .searchable(text: $searchText)
        .font(.custom("Oswald-Regular", size: 16))
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

