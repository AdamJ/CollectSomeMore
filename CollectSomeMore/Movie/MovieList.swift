//
//  MovieList.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/26/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI
import SwiftData
import Foundation

struct MovieCollectionSection: Identifiable {
    let id: String // The letter or '#'
    let items: [MovieCollection]
}

struct MovieList: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.editMode) private var editMode
    
    @State private var currentEditMode: EditMode = .inactive
    @State private var showSearchBar = false
    
    @FocusState private var searchBarIsFocused: Bool
    
    @Query(sort: [SortDescriptor(\MovieCollection.enteredDate, order: .reverse), SortDescriptor(\MovieCollection.movieTitle)]) private var movies: [MovieCollection]
    
    @AppStorage("movieGroupingOption")
    private var selectedGroupingOption: MovieGroupingOption = .movieTitle
    
    enum SortOption: CustomStringConvertible {
        case movieTitle
        case genre
        case studio
        case ratings
        case locations
        
        var description: String {
            switch self {
                case .movieTitle:return "Title"
                case .genre: return "Genre"
                case .studio: return "Studio"
                case .ratings: return "Ratings"
                case .locations: return "Location"
            }
        }
    }
    
    @State private var newCollection: MovieCollection?
    @State private var activeMovieForNavigation = NavigationPath()
    @State private var showingExportSheet = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var searchMoviesText: String = ""
    
    @State private var filterPlatform: String = "All"
    @State private var filterStudio: String = "All"
    
    // MARK: - Multi-select state
    @State private var selectedMovieIDs = Set<UUID>()
    @State private var showDeleteConfirmation = false
    @State private var showMarkWatchedConfirmation = false
    @State private var showMarkUnwatchedConfirmation = false
    
    private var isFilterActive: Bool {
        !searchMoviesText.isEmpty || // is searchText not empty?
        filterPlatform != "All" || // is Platform not "All"
        filterStudio != "All" // is Studio not "All"
    }
    
    private var collections: [MovieCollection] {
        return movies
    }
    private var availableGenres: Set<String> {
        Set(collections.compactMap { $0.genre })
    }
    private var availableStudios: Set<String> {
        Set(collections.compactMap { $0.studio })
    }
    private var availableRatings: Set<String> {
        Set(collections.compactMap { $0.ratings })
    }
    private var availablePlatforms: Set<String> {
        Set(collections.compactMap { $0.platform })
    }
    private var selectedMovies: [MovieCollection] {
        movies.filter { selectedMovieIDs.contains($0.id) }
    }
    
    struct Record {
        var movieTitle: String
        var ratings: String
        var genre: String
        var studio: String
        var platform: String
        var releaseDate: Date
        var purchaseDate: Date
        var locations: String
        var enteredDate: Date
        var notes: String = ""
        var isWatched: Bool = false
        
        init(movieTitle: String, ratings: String, genre: String, studio: String, platform: String, releaseDate: Date, purchaseDate: Date, locations: String, enteredDate: Date, notes: String?, isWatched: Bool = false) {
            self.movieTitle = movieTitle
            self.ratings = ratings
            self.genre = genre
            self.studio = studio
            self.platform = platform
            self.releaseDate = releaseDate
            self.purchaseDate = purchaseDate
            self.locations = locations
            self.enteredDate = enteredDate
            self.notes = notes ?? ""
            self.isWatched = isWatched
        }
        
        func toCSV() -> String {
            return "\(movieTitle),\(ratings),\(genre),\(studio),\(platform),\(releaseDate),\(locations),\(purchaseDate),\(enteredDate),\(notes). \(isWatched)"
        }
    }
    
    var filteredAndSearchedCollections: [MovieCollection] {
        collections
            .filter { item in
                (filterStudio == "All" || item.studio == filterStudio) &&
                (filterPlatform == "All" || item.platform == filterPlatform) &&
                (searchMoviesText.isEmpty || (item.movieTitle?.localizedStandardContains(searchMoviesText) ?? true))
            }
    }
    // --- Updated groupedCollections Computed Property ---
    private var groupedCollections: [MovieCollectionSection] {
        guard !filteredAndSearchedCollections.isEmpty else {
            return []
        }

        let groupedDictionary: [String: [MovieCollection]]

        switch selectedGroupingOption {
        case .movieTitle:
            // Group by first letter, with '#' for non-letters
            groupedDictionary = Dictionary(grouping: filteredAndSearchedCollections) { collection in
                let title = collection.movieTitle ?? ""
                let firstCharacter = title.first?.uppercased() ?? "#"
                let isLetter = firstCharacter.rangeOfCharacter(from: .letters) != nil
                return isLetter ? firstCharacter : "#"
            }
        case .genre:
            groupedDictionary = Dictionary(grouping: filteredAndSearchedCollections) { $0.genre ?? "Unknown Genre" }
        case .studio:
            groupedDictionary = Dictionary(grouping: filteredAndSearchedCollections) { $0.studio ?? "Unknown Studio" }
        case .ratings:
            groupedDictionary = Dictionary(grouping: filteredAndSearchedCollections) { $0.ratings ?? "Unknown Ratings" }
        case .locations:
            groupedDictionary = Dictionary(grouping: filteredAndSearchedCollections) { $0.locations ?? "Unknown Locations" }
        }

        // Sort keys. Handles '#' for .gameTitle, otherwise alphabetical.
        let sortedKeys = groupedDictionary.keys.sorted { key1, key2 in
            if selectedGroupingOption == .movieTitle {
                if key1 == "#" { return false } // # comes after all letters
                if key2 == "#" { return true }  // # comes after all letters
            }
            return key1 < key2                  // Sort other keys alphabetically
        }

        return sortedKeys.map { key in
            let itemsInSection = groupedDictionary[key]!
            // Always sort items within each section by gameTitle for consistency
            let sortedItems = itemsInSection.sorted { item1, item2 in
                (item1.movieTitle ?? "") < (item2.movieTitle ?? "")
            }
            return MovieCollectionSection(id: key, items: sortedItems)
        }
    }
    // --- End Updated groupedCollections ---
    
    @ViewBuilder
    private var movieListToolbar: some View {
        if movies.isEmpty {
        } else {
            ZStack {
                VStack {
                    HStack {
                        HStack {
                            Menu {
                                Picker("Platform", selection: $filterPlatform) {
                                    ForEach(Platform.platforms, id: \.self) { platform in
                                        Text(platform)
                                            .tag(platform)
                                            .disabled(!availablePlatforms.contains(platform) && platform != "All")
                                    }
                                }
                                .pickerStyle(.menu)
                                Picker("Studio", selection: $filterStudio) {
                                    ForEach(Studios.studios, id: \.self) { studio in
                                        Text(studio)
                                            .tag(studio)
                                            .disabled(!availableStudios.contains(studio) && studio != "All")
                                    }
                                }
                                .pickerStyle(.menu)
                            } label: {
                                HStack {
                                    Image(systemName: "line.3.horizontal.decrease") // Keep your icon
                                    Text("Filters")
                                }
                                .foregroundStyle(Color.white)
                                .captionStyle()
                            }
                            .disabled(movies.isEmpty)
                            .menuStyle(FilterMenuStyle())
                        }

                        Menu {
                            Picker("\(selectedGroupingOption)", selection: $selectedGroupingOption) {
                                ForEach(MovieGroupingOption.allCases) { option in
                                    Text(option.displayName).tag(option)
                                }
                            }
                        } label: {
                            HStack {
                                Text("Group by \(selectedGroupingOption.displayName)")
                            }
                            .foregroundStyle(Color.white)
                            .captionStyle()
                        }
                        .disabled(movies.isEmpty)
                        .menuStyle(FilterMenuStyle())
                        
                        Spacer()
                        
                        if isFilterActive {
                            Button("Reset") {
                                searchMoviesText = ""
                                filterPlatform = "All" // Reset to default value
                                filterStudio = "All" // Reset to default value
                            }
                            .foregroundStyle(Colors.onSurface)
                        }
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.4)) { // Animate the visibility change
                                showSearchBar.toggle()
                            }
                            // If hiding, also dismiss keyboard
                            if !showSearchBar {
                                searchBarIsFocused = false
                                searchMoviesText = "" // Clear text when hidden
                            }
                        } label: {
                            if UIDevice.current.userInterfaceIdiom == .pad {
                                Text(showSearchBar ? "Cancel" : "Search")
                            }
                            Image(systemName: showSearchBar ? "xmark" : "magnifyingglass")
                        }
                        .padding(.vertical, Sizing.SpacerXSmall)
                        .padding(.horizontal, Sizing.SpacerSmall)
                        .background(Color.gray05.opacity(0.2))
                        .foregroundStyle(Color.white)
                        .captionStyle()
                        .clipShape(RoundedRectangle(cornerRadius: Sizing.SpacerMedium))
                    }
                    .padding(.top, Sizing.SpacerSmall)
                    .padding(.bottom, Sizing.SpacerSmall)
                    .padding(.horizontal)
                    .background(.secondaryContainer)
                    .colorScheme(.dark)
                    if showSearchBar {
                        CustomSearchBar(searchText: $searchMoviesText, placeholder: "Search movies...", isFocused: _searchBarIsFocused)
                            .transition(.move(edge: .trailing))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    searchBarIsFocused = true
                                }
                            }
                            .padding(.bottom, Sizing.SpacerSmall)
                            .background(.secondaryContainer)
                            .colorScheme(.dark)
                    }
                }
            }
            .background(.secondaryContainer)
            .colorScheme(.dark)
        }
    }
    
    @ViewBuilder
    private var movieEmptyContent: some View {
        ContentUnavailableView {
            Label("Empty Movie Collection", systemImage: "film.fill")
                .padding()
                .titleStyle()
            Text("Add movies to start building your collection.")
                .bodyStyle()
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Colors.surfaceLevel)
        .scrollContentBackground(.hidden)
        .navigationTitle("Movies (\(filteredAndSearchedCollections.count) / (\(movies.count))")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(Colors.secondaryContainer, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button(action: addCollection) {
                    Label("Add Movie", systemImage: "plus.app")
                }
            }
        }
    }
    
    @ViewBuilder
    private var movieFilteredEmpty: some View {
        ContentUnavailableView {
            VStack {
                Image(systemName: "xmark.bin")
                    .foregroundColor(.secondary)
                    .font(.system(size: 72))
                    .multilineTextAlignment(.center)
                Text("No movies match your criteria")
                    .padding()
                    .title2Style()
                Text("Try adjusting your filters")
                    .subtitleStyle()
                VStack {
                    HStack(alignment: .center, spacing: 0) {
                        HStack(alignment: .center, spacing: Sizing.SpacerSmall) {
                            Text("Platform: \(filterPlatform)")
                                .padding(.top, Sizing.SpacerXSmall)
                                .padding(.trailing, Sizing.SpacerMedium)
                                .padding(.bottom, Sizing.SpacerXSmall)
                                .padding(.leading, Sizing.SpacerMedium)
                                .foregroundColor(Colors.onSurface)
                                .bodyBoldStyle()
                                .multilineTextAlignment(.center)
                        }
                        .padding(.leading, Sizing.SpacerSmall)
                        .padding(.trailing, Sizing.SpacerSmall)
                        .padding(.vertical, Sizing.SpacerSmall)
                        .frame(height: 32)
                    }
                    .padding(0)
                    .background(Colors.surfaceContainerLow)
                    .cornerRadius(16)
                    
                    HStack(alignment: .center, spacing: 0) {
                        HStack(alignment: .center, spacing: Sizing.SpacerSmall) {
                            Text("Studio: \(filterStudio)")
                                .padding(.top, Sizing.SpacerXSmall)
                                .padding(.trailing, Sizing.SpacerMedium)
                                .padding(.bottom, Sizing.SpacerXSmall)
                                .padding(.leading, Sizing.SpacerMedium)
                                .foregroundColor(Colors.onSurface)
                                .bodyBoldStyle()
                                .multilineTextAlignment(.center)
                        }
                        .padding(.leading, Sizing.SpacerSmall)
                        .padding(.trailing, Sizing.SpacerSmall)
                        .padding(.vertical, Sizing.SpacerSmall)
                        .frame(height: 32)
                    }
                    .padding(0)
                    .background(Colors.surfaceContainerLow)
                    .cornerRadius(16)
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Colors.surfaceLevel)
        .scrollContentBackground(.hidden)
        .navigationTitle("Movies (\(filteredAndSearchedCollections.count) / (\(movies.count))")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(Colors.secondaryContainer, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button(action: addCollection) {
                    Label("Add Movie", systemImage: "plus.app")
                        .labelStyle(.titleAndIcon)
                }
                .disabled(filteredAndSearchedCollections.isEmpty)
            }
            ToolbarItem(placement: .secondaryAction) {
                Button("Export", systemImage: "square.and.arrow.up") {
                    showingExportSheet = true
                }
                .sheet(isPresented: $showingExportSheet) {
                    if let fileURL = createCSVFile() {
                        ShareSheet(activityItems: [fileURL])
                    }
                }
                .alert("Export Error", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(alertMessage)
                }
            }
        }
    }
    
    @ViewBuilder
    private var movieMainContent: some View {
        List(selection: $selectedMovieIDs) {
            ForEach(groupedCollections) { section in
                Section {
                    ForEach(section.items) { movie in
                        NavigationLink(value: movie) {
                            MovieRowView(movieCollection: movie)
                        }
                        .tint(editMode?.wrappedValue == .active ? Colors.accent : nil)
                        .listRowBackground(
                            selectedMovieIDs.contains(movie.id) ?
                            Colors.accent.opacity(0.2) : Colors.surfaceLevel
                        )
                        .swipeActions(edge: .leading) {
                            Button {
                                toggleWatchedStatus(for: movie)
                            } label: {
                                Label(movie.isWatched ? "Mark Watched" : "Mark Unwatched", systemImage: movie.isWatched ? "xmark.circle.fill" : "checkmark.circle.fill")
                            }
                            .tint(movie.isWatched ? .gray : .blue)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                deleteMovie(movie)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    .onDelete { indexSet in
                         for index in indexSet {
                             let itemToDelete = section.items[index]
                             modelContext.delete(itemToDelete)
                         }
                    }
                } header: {
                    VStack(alignment: .center) {
                        Text(section.id)
                            .padding(.vertical, 0)
                            .padding(.horizontal, Sizing.SpacerXSmall)
                            .background(Color.backgroundGameColor(forSectionID: section.id))
                            .foregroundColor(Color.foregroundGameColor(forSectionID: section.id))
                            .minimalStyle()
                            .fontWeight(.bold)
                    }
                    .cornerRadius(Sizing.SpacerXSmall)
                }
                .minimalStyle()
            }
            .listRowSeparator(.hidden, edges: .all)
            .listRowInsets(.init(top: 0, leading: Sizing.SpacerSmall, bottom: 0, trailing: Sizing.SpacerSmall))
        }
        .listStyle(.plain)
        .listSectionSpacing(.compact)
        .background(Colors.surfaceLevel)
        .scrollContentBackground(.hidden)
        .navigationTitle("Movies (\(filteredAndSearchedCollections.count) / \(movies.count))")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(Colors.secondaryContainer, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button(action: addCollection) {
                    Label("Add Movie", systemImage: "plus.app")
                        .labelStyle(.titleAndIcon)
                }
            }
            ToolbarItem(placement: .secondaryAction) {
                Button("Export", systemImage: "square.and.arrow.up") {
                    showingExportSheet = true
                }
                .sheet(isPresented: $showingExportSheet) {
                    if let fileURL = createCSVFile() {
                        ShareSheet(activityItems: [fileURL])
                    }
                }
                .alert("Export Error", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(alertMessage)
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
            }
            if currentEditMode == .active {
                ToolbarItemGroup(placement: .bottomBar) {
                    // MARK: Watched
                    Button("Watched") {
                        showMarkWatchedConfirmation = true
                    }
                    .captionStyle()
                    .buttonStyle(.borderedProminent)
                    .disabled(selectedMovieIDs.isEmpty || selectedMovies.allSatisfy({ $0.isWatched }))
                    .confirmationDialog("Mark the selected movie(s) as watched?", isPresented: $showMarkWatchedConfirmation, titleVisibility: .visible) {
                        Button("Confirm") {
                            markSelectedMovies(watched: true)
                        }
                        .bodyStyle()
                        Button("Cancel", role: .cancel) {}
                            .bodyStyle()
                    }
                    Spacer()
                    // MARK: Unwatched
                    Button("Unwatched") {
                        showMarkUnwatchedConfirmation = true
                    }
                    .captionStyle()
                    .buttonStyle(.borderedProminent)
                    .disabled(selectedMovieIDs.isEmpty || selectedMovies.allSatisfy({ !$0.isWatched }))
                    .confirmationDialog("Mark the selected movie(s) as unwatched?", isPresented: $showMarkUnwatchedConfirmation, titleVisibility: .visible) {
                        Button("Confirm") {
                            markSelectedMovies(watched: false)
                        }
                        .bodyStyle()
                        Button("Cancel", role: .cancel) {}
                            .bodyStyle()
                    }
                    Spacer()
                    // MARK: Delete
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Text("Delete (\(selectedMovieIDs.count))")
                            .captionStyle()
                            .foregroundStyle(.red)
                    }
                    .disabled(selectedMovieIDs.isEmpty)
                    .confirmationDialog("Delete the selected movie(s)?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
                        Button("Delete", role: .destructive) {
                            deleteSelectedMovies()
                        }
                        .bodyStyle()
                        Button("Cancel", role: .cancel) {}
                            .bodyStyle()
                    }
                }
            }
        }
    }
    var body: some View {
        NavigationStack(path: $activeMovieForNavigation) {
            VStack(alignment: .leading, spacing: Sizing.SpacerNone) {
                movieListToolbar
                if movies.isEmpty {
                    movieEmptyContent
                } else if filteredAndSearchedCollections.isEmpty {
                    movieFilteredEmpty
                } else {
                    movieMainContent
                }
            }
            .padding(.all, 0)
            .environment(\.editMode, $currentEditMode)
            .onChange(of: currentEditMode) { oldValue, newValue in
                if newValue == .inactive {
                    selectedMovieIDs.removeAll()
                }
            }
            .navigationDestination(for: MovieCollection.self) { movie in
                MovieDetail(movieCollection: movie)
                    .onDisappear {
                        activeMovieForNavigation = NavigationPath()
                    }
            }
        }
        .bodyStyle()
        .background(Colors.surfaceLevel)
        .sheet(item: $newCollection) { collection in
            NavigationStack {
                MovieDetail(movieCollection: collection, isNew: true)
            }
            .interactiveDismissDisabled()
            .presentationDetents([.large]) // Use .presentationDetents for sheets
            .onDisappear {}
        }
        
        .onAppear {
            filterStudio = "All"
            filterPlatform = "All"
            activeMovieForNavigation = NavigationPath()
            selectedMovieIDs.removeAll()
        }
    }
    
    private func addCollection() {
        withAnimation {
            let newItem = MovieCollection(id: UUID(), movieTitle: "", ratings: "Unrated", genre: "Other", studio: "None", platform: "None", releaseDate: .now, purchaseDate: .now, locations: "None", enteredDate: .now, notes: "")
            newCollection = newItem
        }
    }
    
    private func deleteMovie(_ movie: MovieCollection) {
        modelContext.delete(movie)
    }
    
    private func toggleWatchedStatus(for movie: MovieCollection) {
        movie.isWatched.toggle()
    }
    
    private func deleteSelectedMovies() {
        for movieID in selectedMovieIDs {
            if let movieToDelete = movies.first(where: { $0.id == movieID }) {
                modelContext.delete(movieToDelete)
            }
        }
        selectedMovieIDs.removeAll() // Clear selection after deletion
        currentEditMode = .inactive // Set State to inactive after performing action
    }

    private func markSelectedMovies(watched: Bool) {
        for movieID in selectedMovieIDs {
            if let movieToUpdate = movies.first(where: { $0.id == movieID }) {
                movieToUpdate.isWatched = watched
            }
        }
        selectedMovieIDs.removeAll() // Clear selection after action
        currentEditMode = .inactive // Set State to inactive after performing action
    }
    
    private func createCSVFile() -> URL? {
        let headers = "Title,Ratings,Genre,Studio,Platform,Release Date,PurchaseDate,Locations,EnteredDate\n"
        let rows = collections.map { Record(movieTitle: $0.movieTitle ?? "", ratings: $0.ratings ?? "", genre: $0.genre ?? "", studio: $0.studio ?? "", platform: $0.platform ?? "", releaseDate: $0.releaseDate ?? Date(), purchaseDate: $0.purchaseDate ?? Date(), locations: $0.locations ?? "", enteredDate: $0.enteredDate ?? Date(), notes: $0.notes).toCSV() }.joined(separator: "\n")
        let csvContent = headers + rows
        
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            alertMessage = "Could not access documents directory"
            showingAlert = true
            return nil
        }
        
        let fileName = "Movie_Collection_Backup_\(Date().timeIntervalSince1970).csv"
        let fileURL = documentsPath.appendingPathComponent(fileName)
        
        do {
            try csvContent.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            alertMessage = "Error exporting file: \(error.localizedDescription)"
            showingAlert = true
            return nil
        }
    }
}

//#Preview("Movie List View") {
//    MovieList()
//        .modelContainer(GameData.shared.modelContainer)
//}

#Preview("Movie List View with Sample Data") {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: MovieCollection.self, configurations: config)

        // Directly reference the static sample data from GameCollection
        @MainActor func insertSampleData() {
            for movie in MovieCollection.sampleMovieCollectionData { // <-- Reference like this!
                container.mainContext.insert(movie)
            }
        }
        insertSampleData()

        return MovieList()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create ModelContainer for preview: \(error)")
    }
}
