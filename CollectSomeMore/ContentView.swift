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

    var body: some View {
        TabView() {
            Group {
                HomeView()
                    .tabItem {
                        Label("Home", image: .house)
                            .labelStyle(.automatic)
                            .colorScheme(.dark)
                    }
                GameListView()
                    .tabItem {
                        Label("Games", image: .inboxalt)
                            .labelStyle(.automatic)
                            .colorScheme(.dark)
                    }
                MovieList()
                    .tabItem {
                        Label("Movies", image: .film)
                            .labelStyle(.automatic)
                            .imageScale(.large)
                            .colorScheme(.dark)
                    }
                SearchView()
                    .tabItem {
                        Label("Search", image: .search)
                            .labelStyle(.automatic)
                            .colorScheme(.dark)
                    }
            }
            .toolbarBackground(.tabBar, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
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
