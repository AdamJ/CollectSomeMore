//
//  MovieList.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 10/8/24.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI
import SwiftData

struct MovieList: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Query(sort: \MovieCollection.movieTitle) private var collections: [MovieCollection]
    
    enum SortOption {
        case movieTitle, ratings, platform
    }
    
    @State private var newCollection: MovieCollection?
    @State private var sortOption: SortOption = .movieTitle
    @State private var showingExportSheet = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    @State private var filterPlatform: String = "All"
    @State private var filterStudio: String = "All"
    
    let allPossibleStudios: [String] = ["All", "20th Century Fox", "Warner Bros.", "Paramount Pictures", "Sony Pictures", "Disney", "Universal Pictures", "Apple", "Amazon", "Ghibli"]
    let allPossiblePlatforms: [String] = ["All", "Home Theater", "Apple TV+", "Prime Video", "Netflix", "Hulu", "Disney+", "HBO Max", "YouTube", "ESPN+", "Peacock"]
    
    private var availableStudios: Set<String> {
        Set(collections.compactMap { $0.studio })
    }
    private var availablePlatforms: Set<String> {
        Set(collections.compactMap { $0.platform })
    }
    
    struct Record { // Moved Record struct inside MovieList for now
        var movieTitle: String
        var ratings: String
        var genre: String
        var studio: String
        var platform: String
        var releaseDate: Date
        var purchaseDate: Date
        var locations: String
        var enteredDate: Date

        init(movieTitle: String, ratings: String, genre: String, studio: String, platform: String, releaseDate: Date, purchaseDate: Date, locations: String, enteredDate: Date) {
            self.movieTitle = movieTitle
            self.ratings = ratings
            self.genre = genre
            self.studio = studio
            self.platform = platform
            self.releaseDate = releaseDate
            self.purchaseDate = purchaseDate
            self.locations = locations
            self.enteredDate = enteredDate
        }

        func toCSV() -> String {
            return "\(movieTitle),\(ratings),\(genre),\(studio),\(platform),\(releaseDate),\(purchaseDate),\(locations),\(enteredDate)"
        }
    }

    var filteredCollections: [MovieCollection] {
        collections
            .filter { item in
                (filterStudio == "All" || item.studio == filterStudio) &&
                (filterPlatform == "All" || item.platform == filterPlatform)
            }
            .sorted(by: { item1, item2 in
                switch sortOption {
                case .movieTitle:
                    return item1.movieTitle ?? "" < item2.movieTitle ?? ""
                case .ratings:
                    return item1.ratings ?? "" < item2.ratings ?? ""
                case .platform:
                    return item1.platform ?? "" < item2.platform ?? ""
                }
            })
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: Constants.SpacerNone) {
                HStack {
                    Menu("Platform:", systemImage: "line.3.horizontal.decrease.circle") {
                        Picker("System", selection: $filterPlatform) {
                            ForEach(allPossiblePlatforms, id: \.self) { platform in
                                Text(platform)
                                    .tag(platform)
                                    .disabled(!availablePlatforms.contains(platform) && platform != "All Platforms")
                            }
                        }
                        .pickerStyle(.inline)
                    }
                    .font(.custom("Oswald-Regular", size: 16))
                    .padding(.bottom, Constants.SpacerNone)
                    .disabled(collections.isEmpty)
                    Text("\(filterPlatform)")
                        .font(.custom("Oswald-Regular", size: 16))
                    Spacer()
                    Menu("Brand:", systemImage: "line.3.horizontal.decrease.circle") {
                        Picker("Studio", selection: $filterStudio) {
                            ForEach(allPossibleStudios, id: \.self) { studio in
                                Text(studio)
                                    .tag(studio)
                                    .disabled(!availableStudios.contains(studio) && studio != "All")
                            }
                        }
                        .pickerStyle(.inline)
                    }
                    .font(.custom("Oswald-Regular", size: 16))
                    .padding(.bottom, Constants.SpacerNone)
                    .disabled(collections.isEmpty)
                    Text("\(filterStudio)")
                        .font(.custom("Oswald-Regular", size: 16))
                }
                .padding(.horizontal)

                List {
                    if filteredCollections.isEmpty {
                        Label("No games match your filter criteria of \(filterPlatform) and \(filterStudio)", systemImage: "xmark.bin")
                            .padding()
                            .font(.custom("Oswald-Regular", size: 14))
                    } else {
                        ForEach(filteredCollections) { collection in
                            NavigationLink(destination: MovieDetail(movieCollection: collection)) {
                                MovieRowView(movieCollection: collection)
                            }
                            .listRowBackground(Color.transparent)
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
                .padding(.horizontal, Constants.SpacerNone)
                .padding(.vertical, Constants.SpacerNone)
                .scrollContentBackground(.hidden) // Hides the background content of the scrollable area
                .navigationTitle("Movies (\(collections.count))") // Adds a summary count to the page title of the total items in the collections list
                .navigationBarTitleDisplayMode(.large)
                .toolbarBackground(.hidden)
                .toolbar {
                    ToolbarItemGroup(placement: .secondaryAction) {
                        NavigationLink(destination: AboutView()) {
                            Label("About", systemImage: "info.circle")
                        }
                        NavigationLink(destination: HowToAdd()) {
                            Label("How to add movies", systemImage: "questionmark.circle")
                        }
                    }
                    ToolbarItemGroup(placement: .primaryAction) {
                        Button(action: addCollection) {
                            Label("Add Movie", systemImage: "plus.app")
                        }
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
                    }
                    ToolbarItemGroup(placement: .topBarLeading) {
                        EditButton()
                    }
                }
            }
            .padding(.leading, Constants.SpacerNone)
            .padding(.trailing, Constants.SpacerNone)
            .padding(.vertical, Constants.SpacerNone)
            .background(Gradient(colors: darkBottom)) // Default background color for all pages
            .foregroundStyle(.gray09) // Default font color for all pages
            .shadow(color: Color.gray03.opacity(0.16), radius: 8, x: 0, y: 4) // Adds a drop shadow around the List
        }
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
            let newItem = MovieCollection(id: UUID(), movieTitle: "", ratings: "Unrated", genre: "Other", studio: "Unknown", platform: "Unknown", releaseDate: .now, purchaseDate: .now, locations: "None", enteredDate: .now)
            newCollection = newItem
        }
    }

    private func createCSVFile() -> URL? {
        let headers = "Title,Ratings,Genre,Studio,Platform,Release Date,PurchaseDate,Locations,EnteredDate\n"
        let rows = collections.map { Record(movieTitle: $0.movieTitle ?? "", ratings: $0.ratings ?? "", genre: $0.genre ?? "", studio: $0.studio ?? "", platform: $0.platform ?? "", releaseDate: $0.releaseDate ?? Date(), purchaseDate: $0.purchaseDate ?? Date(), locations: $0.locations ?? "", enteredDate: $0.enteredDate ?? Date()).toCSV() }.joined(separator: "\n")
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
