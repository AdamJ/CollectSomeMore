//
//  ContentView.swift
//  CollectSomeMore
//
//  Created by Adam Jolicoeur on 6/7/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Collection.title) private var collections: [Collection]

    @State private var newCollection: Collection?
    @State private var searchText = ""

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            MovieList(collection: CollectionData.shared.collection)
                .tabItem {
                    Label("Movies", systemImage: "popcorn")
                }
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview("Data List") {
    ContentView()
        .navigationTitle("Data List")
        .navigationBarTitleDisplayMode(.automatic)
        .modelContainer(CollectionData.shared.modelContainer)
}

#Preview("Empty List") {
    ContentView()
        .modelContainer(for: Collection.self, inMemory: false)
}
