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
let transparentGradientInverse: [Color] = [
    .transparent,
    .backgroundTertiary
]
let darkBottom: [Color] = [
    .transparent,
    .gradientBottom
]

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Collection.title) private var collections: [Collection]

    @State private var newCollection: Collection?
    @State private var searchText = ""

    var body: some View {
        TabView {
            Group {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                            .labelStyle(.iconOnly)
                    }
                    .background(Gradient(colors: darkBottom))
                MovieList(collection: CollectionData.shared.collection)
                    .tabItem {
                        Label("Movies", systemImage: "books.vertical")
                            .labelStyle(.iconOnly)
                    }
//                    .background(Gradient(colors: transparentGradient))
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                            .labelStyle(.iconOnly)
                    }
//                    .background(Gradient(colors: transparentGradient))
                AboutView()
                    .tabItem {
                        Label("About", systemImage: "info.circle")
                            .labelStyle(.iconOnly)
                    }
//                    .background(Gradient(colors: darkBottom))
            }
            .toolbarBackground(.tabBar, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarColorScheme(.dark, for: .tabBar)
        }
    }
}

#Preview("Content View") {
    ContentView()
        .navigationTitle("Welcome to Game and Things")
        .modelContainer(CollectionData.shared.modelContainer)
        .frame(maxHeight: .infinity)
}
