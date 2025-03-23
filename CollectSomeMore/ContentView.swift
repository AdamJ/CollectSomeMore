//
//  ContentView.swift
//  CollectSomeMore
//
//  Created by Adam Jolicoeur on 6/7/24.
//

import SwiftUI
import SwiftData

let gradientColors: [Color] = [
    .gradientTop,
    .gradientBottom,
    .transparent
]
let transparentBackground: [Color] = [
    .gradientBottom,
    .transparent
]

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
                .background(Gradient(colors: gradientColors))
            MovieList(collection: CollectionData.shared.collection)
                .tabItem {
                    Label("Movies", systemImage: "popcorn")
                }
                .background(Gradient(colors: gradientColors))
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .background(Gradient(colors: gradientColors))
            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
                .background(Gradient(colors: gradientColors))
        }
        .tabViewStyle(.tabBarOnly)
    }
}

#Preview("Home View") {
    ContentView()
        .navigationTitle("Welcome to Game and Things")
        .navigationBarTitleDisplayMode(.inline)
        .modelContainer(CollectionData.shared.modelContainer)
        .background(Gradient(colors: gradientColors))
        .frame(maxHeight: .infinity)
}
