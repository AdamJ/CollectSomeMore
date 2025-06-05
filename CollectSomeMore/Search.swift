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
    
    private var filteredMovies: [MovieCollection] {
        if searchText.isEmpty {
            return []
        } else {
            return collections.filter {
                $0.movieTitle?.localizedCaseInsensitiveContains(searchText) ?? false
            }.sorted { $0.movieTitle ?? "" < $1.movieTitle ?? "" }
        }
    }

    private var filteredGames: [GameCollection] {
        if searchText.isEmpty {
            return []
        } else {
            return games.filter {
                $0.gameTitle?.localizedCaseInsensitiveContains(searchText) ?? false
            }.sorted { $0.gameTitle ?? "" < $1.gameTitle ?? "" }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: Sizing.SpacerSmall)  {
                if !searchText.isEmpty {
                    List {
                        if !filteredGames.isEmpty {
                            Section("Games") {
                                ForEach(filteredGames) { game in
                                    NavigationLink {
                                        GameDetailView(gameCollection: game)
                                    } label: {
                                        GameRowView(gameCollection: game)
                                    }
                                }
                                .listRowSeparator(.hidden, edges: .all)
                                .listRowInsets(.init(top: Sizing.SpacerNone, leading: Sizing.SpacerSmall, bottom: Sizing.SpacerNone, trailing: Sizing.SpacerSmall))
                            }
                            .minimalStyle()
                        }
                        
                        if !filteredMovies.isEmpty {
                            Section("Movies") {
                                ForEach(filteredMovies) { movie in
                                    NavigationLink {
                                        MovieDetail(movieCollection: movie)
                                    } label: {
                                        MovieRowView(movieCollection: movie)
                                    }
                                }
                                .listRowSeparator(.hidden, edges: .all)
                                .listRowInsets(.init(top: Sizing.SpacerNone, leading: Sizing.SpacerSmall, bottom: Sizing.SpacerNone, trailing: Sizing.SpacerSmall))
                            }
                            .minimalStyle()
                        }
                        
                        if filteredMovies.isEmpty && filteredGames.isEmpty {
                            Section("") {
                                HStack {
                                    Image(systemName: "xmark.bin")
                                    Text("No results found")
                                        .bodyStyle()
                                }
                            }
                            .minimalStyle()
                        }
                    }
                    .listStyle(.plain)
                    .listSectionSpacing(.compact)
                    .background(Colors.surfaceContainerLow)  // list background
                    .scrollContentBackground(.hidden) // allows custom background to show through
                    .navigationTitle("Search")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbarBackground(Colors.secondaryContainer, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarColorScheme(.dark)
                } else {
                    ContentUnavailableView {
                        Label("Search all collections", systemImage: "rectangle.and.text.magnifyingglass")
                            .title3Style()
                        Text("by title")
                            .subtitleStyle()
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Colors.surfaceContainerLow)  // list background
                    .scrollContentBackground(.hidden) // allows custom background to show through
                    .navigationTitle("Search")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbarBackground(Colors.secondaryContainer, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarColorScheme(.dark)
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

