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
                    
                    Group {
                        Menu("\(sortOption)", systemImage: "chevron.up.chevron.down.square") {
                            Picker("Sort by", selection: $sortOption) {
                                Text("Title").tag(SortOption.movieTitle)
                                Text("Rating").tag(SortOption.ratings)
                            }
                            .pickerStyle(.automatic)
                        }
                        .bodyStyle()
                        .disabled(collections.isEmpty)
                    }
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
                        ForEach(filteredAndSearchedCollections) { collection in
                            NavigationLink(destination: MovieDetail(movieCollection: collection)) {
                                MovieRowView(movieCollection: collection)
                            }
                            .listRowBackground(Colors.surfaceLevel)
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .background(Colors.surfaceLevel) // list background
                    .scrollContentBackground(.automatic)
                    .navigationTitle("Movies (\(collections.count))")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.hidden)
                    .toolbar {
                        
                        ToolbarItemGroup(placement: .primaryAction) {
                            Button(action: addCollection) {
                                Label("Add Movie", systemImage: "plus.app")
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
                            EditButton()
                            NavigationLink(destination: HowToAdd()) {
                                Label("Adding to a collection", systemImage: "questionmark.circle")
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
            .background(Colors.surfaceLevel)
        }
        .searchable(text: $searchMoviesText, prompt: "Search for a movie")
        .sheet(item: $newCollection) { collection in
            NavigationStack {
                VStack {
                    MovieDetail(movieCollection: collection, isNew: true)
                }
            }
            .interactiveDismissDisabled()
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
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(collections[index])
            }
        }
    }
}

#Preview("Movie List View") {
    MovieList()
        .modelContainer(GameData.shared.modelContainer)
}
