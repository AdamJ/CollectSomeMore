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
        case settings = "Settings" // Changed "info.circle" to "gear" for settings icon

        var id: String { self.rawValue }

        var systemImage: String {
            switch self {
            case .home: return "house"
            case .games: return "gamecontroller.fill"
            case .search: return "rectangle.and.text.magnifyingglass"
            case .movies: return "film.stack"
            case .settings: return "gear" // More common for settings
            }
        }
    }

    var body: some View {
        Group {
            // Use a conditional view based on size class
            if horizontalSizeClass == .regular {
                // MARK: iPad Layout: NavigationSplitView
                NavigationSplitView {
                    // Sidebar: List of NavigationLinks for tabs
                    List(selection: $selectedTab) {
                        ForEach(TabIdentifier.allCases) { tab in
                            NavigationLink(value: tab) {
                                Label(tab.rawValue, systemImage: tab.systemImage)
                            }
                        }
                    }
                    .navigationTitle("Welcome") // Title for the sidebar
                    .toolbarBackground(Color.secondaryContainer, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarColorScheme(.dark, for: .navigationBar)
                } detail: {
                    // Detail view: Display the content of the selected tab
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
                        case .settings:
                            SettingsView()
                        case .none:
                            Text("Select a category from the sidebar.")
                                .font(.title)
                                .foregroundColor(.secondary)
                        }
                    }
                }

            } else {
                // MARK: iPhone Layout: Standard TabView
                TabView {
                    // Tab 1: Home
                    NavigationStack {
                        HomeView()
                    }
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .accessibilityHint(Text("Go to the home screen"))
                    
                    // Tab 2: Games
                    NavigationStack {
                        GameListView()
                    }
                    .tabItem {
                        Label("Games", systemImage: "gamecontroller.fill")
                    }
                    .accessibilityHint(Text("Go to the games screen"))
                    
                    // Tab 3: Search
                    NavigationStack {
                        SearchView()
                    }
                    .tabItem {
                        Label("Search", systemImage: "rectangle.and.text.magnifyingglass")
                    }
                    .accessibilityHint(Text("Go to the search screen"))
                    
                    // Tab 4: Movies
                    NavigationStack {
                        MovieList()
                    }
                    .tabItem {
                        Label("Movies", systemImage: "film.stack")
                    }
                    .accessibilityHint(Text("Go to the movie screen"))
                    
                    // Tab 5: Settings
                    NavigationStack {
                        SettingsView()
                    }
                    .tabItem {
                        Label("Settings", systemImage: "gear") // Consistent icon for settings
                    }
                    .accessibilityHint(Text("Go to the settings screen"))
                }
                .toolbarBackground(Color.secondaryContainer, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
//                // MARK: FAB for iPhone Layout
//                .overlay(alignment: .bottomTrailing) {
//                    Menu {
//                        Button("Add Game") {
//                            addGameCollection()
//                        }
//                        Button("Add Movie") {
//                            addMovieCollection()
//                        }
//                    } label: {
//                        Image(systemName: "plus.circle.fill")
//                            .resizable()
//                            .frame(width: 60, height: 60)
//                            .foregroundColor(.white)
//                            .background(Circle().fill(Color.accentColor))
//                            .shadow(radius: 5)
//                    }
//                    .padding(.trailing, 20)
//                    .padding(.bottom, 80) // Adjusted for tab bar height
//                }
            }
        }
        // MARK: Common Sheet Modifiers for Add Forms
        .sheet(item: $newGameCollection) { game in
            NavigationStack {
                GameDetailView(gameCollection: game, isNew: true)
            }
            .interactiveDismissDisabled()
        }
        .sheet(item: $newMovieCollection) { movie in
            NavigationStack {
                MovieDetail(movieCollection: movie, isNew: true) // Assuming MovieDetail is your movie add/edit view
            }
            .interactiveDismissDisabled()
        }
    }

//    // MARK: - Private Methods
//    private func addMovieCollection() {
//        withAnimation {
//            let newItem = MovieCollection(id: UUID(), movieTitle: "", ratings: "Unrated", genre: "Other", studio: "None", platform: "None", releaseDate: .now, purchaseDate: .now, locations: "None", enteredDate: .now, notes: "")
//            newMovieCollection = newItem
//        }
//    }
//
//    private func addGameCollection() {
//        withAnimation {
//            let newItem = GameCollection(id: UUID(), collectionState: "Owned", gameTitle: "", brand: "All", system: "None", rating: "Unknown", genre: "None", purchaseDate: .now, locations: "None", notes: "", enteredDate: .now)
//            newGameCollection = newItem
//        }
//    }
}

#Preview("Content View") {
    ContentView()
        .modelContainer(for: [GameCollection.self, MovieCollection.self])
}
