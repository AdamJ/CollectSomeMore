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
class SearchModel: ObservableObject {
    @Published var searchText: String = ""
}
struct SearchView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var model: SearchModel
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
            VStack(alignment: .leading, spacing: Sizing.SpacerSmall)  {
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
                                if SearchResultType.movie == item.type {
                                    if let movie = item as? MovieCollection {
                                        MovieRowView(movieCollection: movie)
                                    }
                                } else {}
                                if SearchResultType.game == item.type {
                                    if let game = item as? GameCollection {
                                        GameRowView(gameCollection: game)
                                    }
                                } else {}
                            }
                            .listRowBackground(Colors.surfaceContainerLow) // list item background
                        }
                    }
                    .background(Colors.surfaceLevel)
                    .scrollContentBackground(.hidden)
                    .navigationTitle("Search")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.hidden)
                } else {
                    ContentUnavailableView {
                        Label("Search your collections", systemImage: "magnifyingglass")
                            .title3Style()
                        Text("by title")
                            .bodyStyle()
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Colors.surfaceLevel)
                    .navigationTitle("Search")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
            .padding(.all, Sizing.SpacerNone)
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Search all collections")
        .bodyStyle()
    }
}

#Preview("Basic Search View") {
    SearchView()
        .modelContainer(GameData.shared.modelContainer)
}

