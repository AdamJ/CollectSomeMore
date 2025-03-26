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
    @Query(sort: \Collection.title) private var collections: [Collection]
    @State private var searchText = ""
    @State private var newCollection: Collection?
    
    var body: some View {
        NavigationStack {
            VStack {
                if !searchText.isEmpty {
                    List {
                        ForEach(filteredCollections) { collection in
                            NavigationLink {
                                MovieDetail(collection: collection)
                            } label: {
                                Text(collection.title)
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
            let newItem = Collection(id: UUID(), title: "", ratings: "Unrated", genre: "Other", releaseDate: .now, purchaseDate: .now, locations: "None", enteredDate: .now)
            modelContext.insert(newItem)
            newCollection = newItem
        }
    }
    private var filteredCollections: [Collection] {
        if searchText.isEmpty {
            return collections
        } else {
            return collections.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

#Preview {
    SearchView()
        .modelContainer(CollectionData.shared.modelContainer)
}
