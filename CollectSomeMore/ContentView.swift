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
    var iconColor: Color {
        if selectedTab == 0 {
            return Color.primary
        } else {
            return Color.primary.opacity(0.5)
        }
    }

    var body: some View {
        TabView() {
            Group {
                HomeView()
                    .tag(0)
                    .tabItem {
                        Label("Home", image: .house)
                            .labelStyle(.automatic)
                            .colorScheme(.dark)
                            .foregroundStyle(iconColor)
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
                            .foregroundStyle(iconColor)
                    }
            }
            .toolbarBackground(.tabBar, for: .tabBar)
            .toolbarBackground(.automatic, for: .tabBar)
            .toolbarColorScheme(.dark, for: .tabBar)
        }
    }
}

//#Preview("Content View") {
//    ContentView()
//        .navigationTitle("Welcome to Game and Things")
//        .modelContainer(MovieData.shared.modelContainer)
//        .frame(maxHeight: .infinity)
//}
