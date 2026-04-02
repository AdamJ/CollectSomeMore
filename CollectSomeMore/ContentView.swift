//
//  ContentView.swift
//  CollectSomeMore
//
//  Created by Adam Jolicoeur on 6/7/24.
//

import SwiftUI
import SwiftData
import WebKit

// MARK: - WebView
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

// MARK: - Helper Views for Sheets
struct AddItemsView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        // This view might become redundant if all "add" actions are via FAB
        AddGameView()
    }
}

struct IssuesView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView { // Wrap in NavigationView for proper title and dismiss button
            WebView(url: "https://github.com/AdamJ/CollectSomeMore/issues/")
                .navigationTitle("Issues")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Close") {
                            dismiss()
                        }
                    }
                }
        }
    }
}

struct AppInfoView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView { // Wrap in NavigationView for proper title and dismiss button
            AboutView() // Assuming AboutView itself has a title or toolbar
        }
    }
}

// MARK: - ContentView: The Main View
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @State private var newMovieCollection: MovieCollection?
    @State private var newGameCollection: GameCollection?

    @State private var showingAppInfo = false
    @State private var showingIssuesSheet = false
    @State private var showingFAQSheet = false

    @State private var selectedTab: TabIdentifier? = .home // Default to Home tab

    // Enum to identify each tab
    enum TabIdentifier: String, CaseIterable, Identifiable {
        case home = "Home"
        case games = "Games"
        case search = "Search"
        case movies = "Movies"
        case comics = "Comics"
        case settings = "Settings" // Changed "info.circle" to "gear" for settings icon

        var id: String { self.rawValue }

        var systemImage: String {
            switch self {
            case .home: return "house"
            case .games: return "gamecontroller.fill"
            case .search: return "rectangle.and.text.magnifyingglass"
            case .movies: return "film.stack"
            case .comics: return "book.closed"
            case .settings: return "gear" // More common for settings
            }
        }
    }

    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                NavigationSplitView {
                    List(selection: $selectedTab) {
                        ForEach(TabIdentifier.allCases) { tab in
                            NavigationLink(value: tab) {
                                Label(tab.rawValue, systemImage: tab.systemImage)
                            }
                        }
                    }
                    .navigationTitle("Welcome")
                } detail: {
                    NavigationStack {
                        Group {
                            switch selectedTab {
                            case .home:
                                HomeView()
                            case .games:
                                GameListView()
                            case .search:
                                SearchView()
                            case .movies:
                                MovieList()
                            case .comics:
                                ComicsListView()
                            case .settings:
                                SettingsView()
                            case .none:
                                Text("Select a category from the sidebar.")
                                    .font(.title)
                                    .foregroundColor(Colors.secondary)
                            }
                        }
                    }
                }
            } else {
                TabView {
                    NavigationStack {
                        HomeView()
                    }
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .accessibilityHint(Text("Go to the home screen"))

                    NavigationStack {
                        GameListView()
                    }
                    .tabItem {
                        Label("Games", systemImage: "gamecontroller.fill")
                    }
                    .accessibilityHint(Text("Go to the games screen"))

                    NavigationStack {
                        SearchView()
                    }
                    .tabItem {
                        Label("Search", systemImage: "rectangle.and.text.magnifyingglass")
                    }
                    .accessibilityHint(Text("Go to the search screen"))

                    NavigationStack {
                        MovieList()
                    }
                    .tabItem {
                        Label("Movies", systemImage: "film.stack")
                    }
                    .accessibilityHint(Text("Go to the movie screen"))

                    NavigationStack {
                        SettingsView()
                    }
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .accessibilityHint(Text("Go to the settings screen"))
                }
            }
        }
    }
}

#Preview("Content View") {
    ContentView()
        .modelContainer(for: [GameCollection.self, MovieCollection.self, ComicCollection.self])
}
