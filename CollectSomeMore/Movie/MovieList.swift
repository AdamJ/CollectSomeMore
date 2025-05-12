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
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Query(sort: \MovieCollection.movieTitle) private var collections: [MovieCollection]
    
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
    
    private var isFilterActive: Bool {
        !searchMoviesText.isEmpty || // is searchText not empty?
        filterPlatform != "All" || // is Platform not "All"
        filterStudio != "All" // is Studio not "All"
    }
    
    private var availableStudios: Set<String> {
        Set(collections.compactMap { $0.studio })
    }
    private var availablePlatforms: Set<String> {
        Set(collections.compactMap { $0.platform })
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
        
        init(movieTitle: String, ratings: String, genre: String, studio: String, platform: String, releaseDate: Date, purchaseDate: Date, locations: String, enteredDate: Date, notes: String?) {
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
        }
        
        func toCSV() -> String {
            return "\(movieTitle),\(ratings),\(genre),\(studio),\(platform),\(releaseDate),\(locations),\(purchaseDate),\(enteredDate),\(notes)"
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
    
    // 2. Computed property to group the filtered data by the first letter
    private var groupedCollections: [MovieCollectionSection] {
        guard !filteredAndSearchedCollections.isEmpty else {
            return []
        }

        // Group items by the first letter of the title
        let groupedDictionary = Dictionary(grouping: filteredAndSearchedCollections) { collection in
            let title = collection.movieTitle ?? "" // Handle nil title
            let firstCharacter = title.first?.uppercased() ?? "#" // Get first char, uppercase, default to #
            // Check if it's an alphabet letter
            let isLetter = firstCharacter.rangeOfCharacter(from: .letters) != nil
            return isLetter ? firstCharacter : "#" // Group by letter or '#'
        }

        // Sort the keys (A, B, C, ..., #)
        let sortedKeys = groupedDictionary.keys.sorted { key1, key2 in
            if key1 == "#" { return false } // # comes after all letters
            if key2 == "#" { return true }  // # comes after all letters
            return key1 < key2              // Sort letters alphabetically
        }

        // Create GameCollectionSection objects, sorting items within each section
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
                    .disabled(collections.isEmpty)
                    
                    Spacer()

                }
                .padding(.top, Sizing.SpacerSmall)
                .padding(.bottom, Sizing.SpacerSmall)
                .padding(.horizontal)
                .background(Colors.secondaryContainer)

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
                    .navigationBarTitleDisplayMode(.inline)
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
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            if isFilterActive {
                                Button("Reset") {
                                    // --- Reset Action ---
                                    // Set each filter state variable back to its default value
                                    searchMoviesText = ""
                                    filterPlatform = "All" // Reset to default value
                                    filterStudio = "All" // Reset to default value
                                }
                            }
                        }
                    }
                } else {
                    List {
                        ForEach(groupedCollections) { section in
                            // Section header (the letter or '#')
                            Section(header: Text(section.id)) {
                                // Inner ForEach iterates through the items within this section
                                ForEach(section.items) { collection in
                                    NavigationLink(destination: MovieDetail(movieCollection: collection)) {
                                        MovieRowView(movieCollection: collection) // Your custom row view
                                    }
                                    // Apply listRowBackground to the row
                                    // .listRowBackground(Colors.surfaceContainerLow) // Re-add if needed
                                }
                                // Apply onDelete to the inner ForEach for the rows in the section
                                .onDelete { indexSet in
                                     // Handle Deletion: Delete the actual item(s) from the context
                                     // SwiftData will automatically update the @Query and groupedCollections
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
                    .background(Colors.surfaceLevel) // list background
                    .scrollContentBackground(.hidden)
                    .navigationTitle("Movies (\(collections.count))")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.hidden)
                    .toolbar {
                        
                        ToolbarItemGroup(placement: .primaryAction) {
                            Button(action: addCollection) {
                                Label("Add Movie", systemImage: "plus.app")
                                    .labelStyle(.titleAndIcon)
                            }
                        }
                        
                        ToolbarItemGroup(placement: .secondaryAction) {
                            Button("Export", systemImage: "square.and.arrow.up") {
                                showingExportSheet = true
                            }
                            .sheet(isPresented: $showingExportSheet) {
                                if let fileURL = createCSVFile() {
                                    ShareSheet(activityItems: [fileURL])
                                } else {
                                    // Handle the case where CSV creation failed, maybe keep the alert
                                }
                            }
                            .alert("Export Error", isPresented: $showingAlert) {
                                Button("OK", role: .cancel) { }
                            } message: {
                                Text(alertMessage)
                            }
                            Button("Adding to a collection", systemImage: "questionmark.circle") {
                                showingAddSheet = true
                            }
                            .sheet(isPresented: $showingAddSheet) {
                                HowToAdd()
                            }
                        }
                        ToolbarItem(placement: .topBarLeading) {
                            if isFilterActive {
                                Button("Reset") {
                                    // --- Reset Action ---
                                    // Set each filter state variable back to its default value
                                    searchMoviesText = ""
                                    filterPlatform = "All" // Reset to default value
                                    filterStudio = "All" // Reset to default value
                                }
                            }
                        }
                    }
                }
            }
            .padding(.all, Sizing.SpacerNone)
        }
        .searchable(text: $searchMoviesText, placement: .navigationBarDrawer, prompt: "Search for a movie")
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

#Preview("Movie List View") {
    MovieList()
        .modelContainer(GameData.shared.modelContainer)
}
