//
//  Search.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 10/8/24.
//
import SwiftUI
import SwiftData

struct SearchView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MovieCollection.movieTitle) private var collections: [MovieCollection]
    @Query private var games: [GameCollection]
    @State private var searchText = ""
    @State private var newCollection: MovieCollection?
    
    var body: some View {
        NavigationStack {
            VStack {
                if !searchText.isEmpty {
                    List {
                        ForEach(filteredCollections) { movieCollection in
                            NavigationLink {
                                MovieDetail(movieCollection: movieCollection)
                            } label: {
                                Text(movieCollection.movieTitle)
                            }
                        }
                        .listRowBackground(Color.gray01)
                    }
                    .padding(.horizontal, Constants.SpacerNone)
                    .padding(.vertical, Constants.SpacerNone)
                    .scrollContentBackground(.hidden) // Hides the background content of the scrollable area
                } else {
                    ContentUnavailableView {
                        Label("No results found", systemImage: "magnifyingglass")
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
    private var filteredCollections: [MovieCollection] {
        if searchText.isEmpty {
            return collections
        } else {
            return collections.filter { $0.movieTitle.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

//#Preview {
//    SearchView()
//        .modelContainer(MovieData.shared.modelContainer)
//}
