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
extension CD_MovieCollection: SearchableItem {
    var title: String { movieTitle ?? "" }
    var type: SearchResultType { .movie }
}
extension CD_GameCollection: SearchableItem {
    var title: String { gameTitle ?? "" }
    var type: SearchResultType { .game }
}
class SearchModel: ObservableObject {
    @Published var searchText: String = ""
}
struct SearchView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CD_MovieCollection.movieTitle) private var collections: [CD_MovieCollection]
    @Query(sort: \CD_GameCollection.gameTitle) private var games: [CD_GameCollection]
    
    @State private var searchText = ""
    @State private var newMovieCollection: CD_MovieCollection?
    @State private var newGameCollection: CD_GameCollection?
    
    @State private var showSearchBar = false
    @FocusState private var searchBarIsFocused: Bool
    
    private var filteredMovies: [CD_MovieCollection] {
        if searchText.isEmpty {
            return []
        } else {
            return collections.filter {
                $0.movieTitle?.localizedCaseInsensitiveContains(searchText) ?? false
            }.sorted { $0.movieTitle ?? "" < $1.movieTitle ?? "" }
        }
    }

    private var filteredGames: [CD_GameCollection] {
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
            VStack(alignment: .leading, spacing: Sizing.SpacerSmall) {
                ZStack {
                    VStack {
                        HStack {
                            CustomSearchBar(searchText: $searchText, placeholder: "Search all collections...")
                                .transition(.move(edge: .top))
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                        searchBarIsFocused = true
                                    }
                                }
                                .background(.secondaryContainer)
                                .colorScheme(.dark)
                        }
                        .padding(.top, Sizing.SpacerSmall)
                        .padding(.bottom, Sizing.SpacerSmall)
                        .padding(.horizontal)
                        .background(.secondaryContainer)
                        .colorScheme(.dark)
                    }
                    .padding(.bottom, 0)
                    .padding(.top, 0)
                }

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
                    .background(Colors.surfaceLevel)
                    .scrollContentBackground(.hidden)
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
                    .background(Colors.surfaceLevel)
                    .scrollContentBackground(.hidden)
                    .navigationTitle("Search")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbarBackground(Colors.secondaryContainer, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarColorScheme(.dark)
                }
            }
        }
        .bodyStyle()
        .background(Color.surfaceLevel)
    }
    // MARK: - Private Methods
    private func addMovieCollection() {
        withAnimation {
            let newItem = CD_MovieCollection(id: UUID(), movieTitle: "", ratings: "Unrated", genre: "Other", studio: "None", platform: "None", releaseDate: .now, purchaseDate: .now, locations: "None", enteredDate: .now, notes: "")
            newMovieCollection = newItem
        }
    }

    private func addGameCollection() {
        withAnimation {
            let newItem = CD_GameCollection(id: UUID(), collectionState: "Owned", gameTitle: "", brand: "All", system: "None", rating: "Unknown", genre: "None", purchaseDate: .now, locations: "None", notes: "", enteredDate: .now)
            newGameCollection = newItem
        }
    }
}

#Preview("Basic Search View") {
    SearchView()
        .modelContainer(GameData.shared.modelContainer)
}

