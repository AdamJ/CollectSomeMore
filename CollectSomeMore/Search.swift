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
            ZStack {
                Colors.surfaceLevel
                    .opacity(1)
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: Sizing.SpacerSmall)  {
                    Rectangle()
                        .frame(height: 0)
                        .background(Colors.surfaceContainerLow)
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
                                        .bodyStyle()
                                }
                                .listRowBackground(Color.gray01)
                            }
                        }
                        .padding(.horizontal, Sizing.SpacerNone)
                        .padding(.vertical, Sizing.SpacerNone)
                        .scrollContentBackground(.automatic)
                        .navigationTitle("Search")
                        .navigationBarTitleDisplayMode(.automatic)
                        .toolbarBackground(.hidden)
                    } else {
                        ContentUnavailableView {
                            Label("Search your collections", systemImage: "magnifyingglass")
                                .title2Style()
                            Text("by title")
                                .bodyStyle()
                                .foregroundStyle(.secondary)
                        }
                        .navigationTitle("Search")
                        .navigationBarTitleDisplayMode(.inline)
                        .padding(.horizontal, Sizing.SpacerNone)
                        .padding(.vertical, Sizing.SpacerNone)
                    }
                }
                .padding(.leading, Sizing.SpacerNone)
                .padding(.trailing, Sizing.SpacerNone)
                .padding(.vertical, Sizing.SpacerNone)
            }
        }
        .searchable(text: $searchText, placement: .sidebar)
        .bodyStyle()
    }
}

#Preview("Basic Search View") {
    SearchView()
        .modelContainer(GameData.shared.modelContainer)
}

