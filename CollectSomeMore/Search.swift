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
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredCollections) { collection in
                    NavigationLink {
                        MovieDetail(collection: collection)
                    } label: {
                        Text(collection.title)
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .navigationTitle("Search")
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
