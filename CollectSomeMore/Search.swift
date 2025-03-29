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
    @State private var newCollection: MovieCollection?
    
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
                            }
                            .listRowBackground(Color.gray01)
                        }
                    }
                    .padding(.horizontal, Constants.SpacerNone)
                    .padding(.vertical, Constants.SpacerNone)
                    .scrollContentBackground(.hidden) // Hides the background content of the scrollable area
                } else {
                    ContentUnavailableView {
                        Label("Search your collections", systemImage: "magnifyingglass")
                    }
                    .navigationTitle("Search")
                    .navigationBarTitleDisplayMode(.large)
                }
            }
            .background(Gradient(colors: darkBottom)) // Default background color for all pages
        }
        .searchable(text: $searchText)
        .navigationTitle("Search")
    }
    private func addCollection() {
        withAnimation {
            let newItem = MovieCollection(id: UUID(), movieTitle: "", ratings: "Unrated", genre: "Other", releaseDate: .now, purchaseDate: .now, locations: "None", enteredDate: .now)
            modelContext.insert(newItem)
            newCollection = newItem
        }
    }
}

//#Preview {
//    SearchView()
//        .modelContainer(MovieData.shared.modelContainer)
//}
