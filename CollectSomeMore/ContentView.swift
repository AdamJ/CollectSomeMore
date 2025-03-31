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
    @State private var searchText = ""
    @State private var selectedTab = 0
    let activeColor = Color.accentColor
    let inactiveColor = Color.gray04

    var body: some View {
        TabView(selection: $selectedTab) {
            Group {
                HomeView()
                    .tag(0)
                    .tabItem {
                        Label("Home", image: .house)
                            .labelStyle(.automatic)
                            .colorScheme(.dark)
                    }
                GameListView()
                    .tag(2)
                    .tabItem {
                        Label("Games", image: .controller)
                            .labelStyle(.automatic)
                            .colorScheme(.dark)
                    }
                MovieList()
                    .tag(1)
                    .tabItem {
                        Label("Movies", image: .film)
                            .labelStyle(.automatic)
                            .imageScale(.large)
                            .colorScheme(.dark)
                    }
                SearchView()
                    .tag(3)
                    .tabItem {
                        Label("Search", image: .search)
                            .labelStyle(.automatic)
                            .colorScheme(.dark)
                    }
                AboutView()
                    .tag(4)
                    .tabItem {
                        Label("About", systemImage: "info")
                            .labelStyle(.automatic)
                            .colorScheme(.dark)
                    }
            }
            .toolbarBackground(.tabBar, for: .tabBar)
            .toolbarBackground(.automatic, for: .tabBar)
            .toolbarColorScheme(.dark, for: .tabBar)
            .tint(Color.green)
        }
    }
}

//#Preview("Content View") {
//    ContentView()
//        .navigationTitle("Welcome to Game and Things")
//        .modelContainer(MovieData.shared.modelContainer)
//        .frame(maxHeight: .infinity)
//}
