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
    
    @Query(sort: [SortDescriptor(\MovieCollection.enteredDate, order: .reverse), SortDescriptor(\MovieCollection.movieTitle)]) private var movies: [MovieCollection]
    
    enum SortOption: CustomStringConvertible {
        case movieTitle
        case ratings
        
        var description: String {
            switch self {
            case .movieTitle:
                return "Title"
            case .ratings:
                return "Ratings"
            }
        }
    }
    
    @State private var newCollection: MovieCollection?
    @State private var sortOption: SortOption = .movieTitle
    @State private var showingExportSheet = false
    @State private var showingAlert = false
    @State private var showingAddSheet = false
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
        return movies // Assumes 'collections' should be 'movies'
    }
    
    private var availableStudios: Set<String> {
        Set(collections.compactMap { $0.studio })
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
            .sorted(by: { item1, item2 in
                switch sortOption {
                case .movieTitle:
                    return item1.movieTitle ?? "Title" < item2.movieTitle ?? "Title"
                case .ratings:
                    return item1.ratings ?? "" < item2.ratings ?? ""
                }
            })
    }
    
    private var groupedCollections: [MovieCollectionSection] {
        guard !filteredAndSearchedCollections.isEmpty else {
            return []
        }

        let groupedDictionary = Dictionary(grouping: filteredAndSearchedCollections) { collection in
            let title = collection.movieTitle ?? ""
            let firstCharacter = title.first?.uppercased() ?? "#"
            let isLetter = firstCharacter.rangeOfCharacter(from: .letters) != nil
            return isLetter ? firstCharacter : "#"
        }

        let sortedKeys = groupedDictionary.keys.sorted { key1, key2 in
            if key1 == "#" { return false } // # comes after all letters
            if key2 == "#" { return true }  // # comes after all letters
            return key1 < key2              // Sort letters alphabetically
        }

        return sortedKeys.map { key in
            let itemsInSection = groupedDictionary[key]! // Get the items for this key
            let sortedItems = itemsInSection.sorted { item1, item2 in
                // Sort items within the section alphabetically by gameTitle
                (item1.movieTitle ?? "") < (item2.movieTitle ?? "")
            }
            return MovieCollectionSection(id: key, items: sortedItems)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: Sizing.SpacerNone) {
                if collections.isEmpty {
                } else {
                    HStack {
                        Menu("Filter", systemImage: "line.3.horizontal.decrease.circle") {
                            Picker("Platform", selection: $filterPlatform) {
                                ForEach(Platform.platforms, id: \.self) { platform in
                                    Text(platform)
                                        .tag(platform)
                                        .disabled(!availablePlatforms.contains(platform) && platform != "All")
                                }
                            }
                            .pickerStyle(.menu)
                            .bodyStyle()
                            
                            Text("\(filterPlatform)")
                                .bodyStyle()
                            
                            Menu("Studio") {
                                Picker("Studio", selection: $filterStudio) {
                                    ForEach(Studios.studios, id: \.self) { studio in
                                        Text(studio)
                                            .tag(studio)
                                            .disabled(!availableStudios.contains(studio) && studio != "All")
                                    }
                                }
                            }
                            .bodyStyle()
                            
                            Text("\(filterStudio)")
                                .bodyStyle()
                        }
                        .bodyStyle()
                        .foregroundStyle(Colors.onSurface)
                        .disabled(collections.isEmpty)
                        
                        Spacer()
                    }
                    .padding(.top, Sizing.SpacerSmall)
                    .padding(.bottom, Sizing.SpacerSmall)
                    .padding(.horizontal)
                    .background(Colors.primaryMaterial)
                    .colorScheme(.dark)
                }

                if collections.isEmpty { // Show empty state when there are no movies
                    ContentUnavailableView {
                        Label("No Movies in Your Collection", systemImage: "film.fill")
                            .padding()
                            .titleStyle()
                        Text("Add movies to start building your collection.")
                            .bodyStyle()
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .navigationTitle("Movies (\(collections.count))")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbarBackground(Colors.primaryMaterial, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarColorScheme(.dark)
                    .toolbar {
                        ToolbarItemGroup(placement: .primaryAction) {
                            Button(action: addCollection) {
                                Label("Add Movie", systemImage: "plus.app")
                            }
                        }
                    }
                } else if filteredAndSearchedCollections.isEmpty {
                    ContentUnavailableView {
                        Label("No movies match your criteria", systemImage: "xmark.bin")
                            .padding()
                            .title2Style()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .navigationTitle("Movies (\(collections.count))")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbarBackground(Colors.primaryMaterial, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarColorScheme(.dark)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            if isFilterActive {
                                Button("Reset") {
                                    searchMoviesText = ""
                                    filterPlatform = "All"
                                    filterStudio = "All"
                                }
                            }
                        }
                    }
                } else {
                    List(selection: $selectedMovieIDs) {
                        ForEach(groupedCollections) { section in
                            Section(header: Text(section.id)) {
                                ForEach(section.items) { collection in
                                    NavigationLink(destination: MovieDetail(movieCollection: collection)) {
                                        MovieRowView(movieCollection: collection)
                                    }
                                    // Apply listRowBackground to the row
                                    // .listRowBackground(Colors.surfaceContainerLow) // Re-add if needed
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            toggleWatchedStatus(for: collection)
                                        } label: {
                                            Label(collection.isWatched ? "Mark Watched" : "Mark Unwatched", systemImage: collection.isWatched ? "xmark.circle.fill" : "checkmark.circle.fill")
                                        }
                                        .tint(collection.isWatched ? .orange : .green)
                                    }
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            deleteMovie(collection)
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
                            }
                            .minimalStyle()
                        }
                    }
                    .listSectionSpacing(.compact)
                    .background(Colors.surfaceContainerLow)  // list background
                    .scrollContentBackground(.hidden)
                    .navigationTitle("Movies (\(collections.count))")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbarBackground(Colors.primaryMaterial, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarColorScheme(.dark)
                    .toolbar {
                        ToolbarItemGroup(placement: .primaryAction) {
                            Button(action: addCollection) {
                                Label("Add Movie", systemImage: "plus.app")
                                    .labelStyle(.titleAndIcon)
                            }
                        }
                        ToolbarItemGroup(placement: .secondaryAction) {
                            Button("Adding to a collection", systemImage: "questionmark.circle") {
                                showingAddSheet = true
                            }
                            .sheet(isPresented: $showingAddSheet) {
                                HowToAdd()
                            }
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
                            
                            if isFilterActive {
                                Button("Reset") {
                                    searchMoviesText = ""
                                    filterPlatform = "All" // Reset to default value
                                    filterStudio = "All" // Reset to default value
                                }
                            }
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
                                .backgroundStyle(.orange)
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
            }
            .padding(.all, Sizing.SpacerNone)
            .environment(\.editMode, $currentEditMode)
            .onChange(of: currentEditMode) { oldValue, newValue in
                if newValue == .inactive {
                    selectedMovieIDs.removeAll()
                }
            }
        }
        .searchable(
            text: $searchMoviesText,
            placement: .navigationBarDrawer(displayMode: .automatic),
            prompt: "Search movie collection"
        )
        .bodyStyle()
        .sheet(item: $newCollection) { collection in
            NavigationStack {
                VStack {
                    MovieDetail(movieCollection: collection, isNew: true)
                }
            }
            .interactiveDismissDisabled()
        }
        
        .onAppear {
            filterStudio = "All"
            filterPlatform = "All"
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

extension MovieCollection: Hashable {
    public static func == (lhs: MovieCollection, rhs: MovieCollection) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
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
