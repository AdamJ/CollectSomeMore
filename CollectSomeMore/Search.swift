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
        VStack {
//            List {
//                ForEach(filteredCollections) { collection in
//                    NavigationLink {
//                        MovieDetail(collection: collection)
//                    } label: {
//                        Text(collection.title)
//                    }
//                }
//            }
            if !searchText.isEmpty {
                List {
                    ForEach(filteredCollections) { collection in
                        NavigationLink {
                            MovieDetail(collection: collection)
                        } label: {
                            Text(collection.title)
                                .foregroundColor(.text)
                                .font(.title2)
                        }
                    }
                }
                .navigationTitle(Text("Search results for \"\(searchText)\""))
                Spacer()
                    .navigationBarTitleDisplayMode(.automatic)
            } else if searchText.count == 0 {
                ContentUnavailableView {
                    Label("No items", systemImage: "magnifyingglass")
                }
            } else {
                ContentUnavailableView {
                    Label("No results found", systemImage: "magnifyingglass")
                    Button("Add a movie", action: addCollection)
                        .buttonStyle(.borderedProminent)
                        .padding()
                }
            }
        }
        .searchable(text: $searchText)
        .navigationTitle("Search")
    }
    private func addCollection() {
        withAnimation {
            let newItem = Collection(id: UUID(), title: "", ratings: "R", genre: "Action", releaseDate: .now, purchaseDate: Date(timeIntervalSinceNow: -5_000_000), locations: "Cabinet")
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
        .background(Gradient(colors: transparentBackground))
}
