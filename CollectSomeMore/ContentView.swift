//
//  ContentView.swift
//  CollectSomeMore
//
//  Created by Adam Jolicoeur on 6/7/24.
//

import SwiftUI
import SwiftData

let gradientColors: [Color] = [
    .transparent,
    .gradientTop,
    .gradientBottom,
    .transparent
]
let transparentGradient: [Color] = [
    .backgroundTertiary,
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
                        .labelStyle(.titleAndIcon)
                }
                .background(Gradient(colors: transparentGradient))
            MovieList(collection: CollectionData.shared.collection)
                .tabItem {
                    Label("Movies", systemImage: "popcorn")
                        .labelStyle(.titleAndIcon)
                }
                .background(Gradient(colors: transparentGradient))
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                        .labelStyle(.titleAndIcon)
                }
                .background(Gradient(colors: transparentGradient))
            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                        .labelStyle(.titleAndIcon)
                }
                .background(Gradient(colors: transparentGradient))
        }
        .tabViewStyle(.tabBarOnly)
    }
}

#Preview("Home View") {
    ContentView()
        .navigationTitle("Welcome to Game and Things")
        .modelContainer(CollectionData.shared.modelContainer)
        .background(Gradient(colors: transparentGradient))
        .frame(maxHeight: .infinity)
}
