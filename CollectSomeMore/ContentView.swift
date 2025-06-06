//
//  ContentView.swift
//  CollectSomeMore
//
//  Created by Adam Jolicoeur on 6/7/24.
//

import SwiftUI
import SwiftData
import WebKit

struct WebView: UIViewRepresentable {
    let url: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

struct AddItemsView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        AddGameView()
    }
}

struct FAQView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        WebView(url: "https://github.com/AdamJ/CollectSomeMore/wiki/FAQ")
            .frame(width: UIScreen.main.bounds.size.width)
    }
}

struct IssuesView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        WebView(url: "https://github.com/AdamJ/CollectSomeMore/issues/")
            .frame(width: UIScreen.main.bounds.size.width)
    }
}

struct AppInfoView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        AboutView()
            .frame(width: UIScreen.main.bounds.size.width)
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var newMovieCollection: MovieCollection?
    @State private var newGameCollection: GameCollection?
    @State private var showingAddSheet = false
    @State private var showingAppInfo = false
    @State private var showingIssuesSheet = false
    @State private var showingFAQSheet = false

    var body: some View {
        TabView {
            // Tab 1: Home
            NavigationView { // Use NavigationView or NavigationStack for each tab's content
                HomeView()
                    .toolbarBackground(Color.secondaryContainer, for: .tabBar)
                    .toolbarColorScheme(.dark, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .accessibilityHint(Text("Go to the home screen"))
            
            // Tab 2: Games
            NavigationView { // Use NavigationView or NavigationStack for each tab's content
                GameListView()
                    .toolbarBackground(Color.secondaryContainer, for: .tabBar)
                    .toolbarColorScheme(.dark, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
            }
            .tabItem {
                Label("Games", systemImage: "gamecontroller.fill")
            }
            .accessibilityHint(Text("Go to the games screen"))
            
            // Tab 3: Search
            NavigationView { // Use NavigationView or NavigationStack for each tab's content
                SearchView()
                    .toolbarBackground(Color.secondaryContainer, for: .tabBar)
                    .toolbarColorScheme(.dark, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
            }
            .tabItem {
                Label("Search", systemImage: "rectangle.and.text.magnifyingglass")
            }
            .accessibilityHint(Text("Go to the search screen"))
            
            // Tab 4: Movies
            NavigationView { // Use NavigationView or NavigationStack for each tab's content
                MovieList()
                    .toolbarBackground(Color.secondaryContainer, for: .tabBar)
                    .toolbarColorScheme(.dark, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
            }
            .tabItem {
                Label("Movies", systemImage: "film.stack")
            }
            .accessibilityHint(Text("Go to the movie screen"))
            
            // Tab 5: Settings
            NavigationView { // Use NavigationView or NavigationStack for each tab's content
                SettingsView()
                    .toolbarBackground(Color.secondaryContainer, for: .tabBar)
                    .toolbarColorScheme(.dark, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
            }
            .tabItem {
                Label("Settings", systemImage: "info.circle")
            }
            .accessibilityHint(Text("Go to the settings screen"))
            
            // Tab 6: Add
            NavigationView { // Use NavigationView or NavigationStack for each tab's content
                AddCollectionView()
                    .toolbarBackground(Color.secondaryContainer, for: .tabBar)
                    .toolbarColorScheme(.dark, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
            }
            .tabItem {
                Label("Add", systemImage: "info.circle")
            }
            .accessibilityHint(Text("Go to the add shortcuts screen"))
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabViewSidebarFooter {
            
            HStack {
                Button(action: {
                    self.showingAppInfo.toggle()
                }) {
                    Text("About")
                        .bodyStyle()
                }
                .sheet(isPresented: $showingAppInfo, content: AppInfoView.init)
                
                Button(action: {
                    self.showingFAQSheet.toggle()
                }) {
                    Text("FAQ")
                        .bodyStyle()
                }
                .sheet(isPresented: $showingFAQSheet, content: FAQView.init)
                
                Button(action: {
                    self.showingIssuesSheet.toggle()
                }) {
                    Text("Issues")
                        .bodyStyle()
                }
                .sheet(isPresented: $showingIssuesSheet, content: IssuesView.init)
            }
        }
    }
    
    private func addMovieCollection() {
        withAnimation {
            let newItem = MovieCollection(id: UUID(), movieTitle: "", ratings: "Unrated", genre: "Other", studio: "None", platform: "None", releaseDate: .now, purchaseDate: .now, locations: "None", enteredDate: .now, notes: "")
            newMovieCollection = newItem
        }
    }
    private func addGameCollection() {
        withAnimation {
            let newItem = GameCollection(id: UUID(), collectionState: "Owned", gameTitle: "", brand: "All", system: "None", rating: "Unknown", genre: "None", purchaseDate: .now, locations: "None", notes: "", enteredDate: .now)
            newGameCollection = newItem
        }
    }
}

#Preview("Content View") {
    ContentView()
        .modelContainer(for: [GameCollection.self, MovieCollection.self])
}
