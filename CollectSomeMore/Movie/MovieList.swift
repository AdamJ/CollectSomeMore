//
//  MovieList.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 10/8/24.
//

import SwiftUI
import SwiftData

struct MovieList: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Query(sort: \MovieCollection.movieTitle) private var collections: [MovieCollection]
    @Query private var games: [GameCollection]

    enum SortOption {
        case movieTitle, ratings
    }

    @State private var newCollection: MovieCollection?
    @State private var sortOption: SortOption = .movieTitle
    @State private var showingExportSheet = false
    @State private var showingAlert = false
    @State private var alertMessage = ""

    struct Record { // Moved Record struct inside MovieList for now
        var movieTitle: String
        var ratings: String
        var genre: String
        var releaseDate: Date
        var purchaseDate: Date
        var locations: String
        var enteredDate: Date

        init(movieTitle: String, ratings: String, genre: String, releaseDate: Date, purchaseDate: Date, locations: String, enteredDate: Date) {
            self.movieTitle = movieTitle
            self.ratings = ratings
            self.genre = genre
            self.releaseDate = releaseDate
            self.purchaseDate = purchaseDate
            self.locations = locations
            self.enteredDate = enteredDate
        }

        func toCSV() -> String {
            return "\(movieTitle),\(ratings),\(genre),\(releaseDate),\(purchaseDate),\(locations),\(enteredDate)"
        }
    }

    var sortedCollections: [MovieCollection] {
        switch sortOption {
            case .movieTitle:
                return collections.sorted { $0.movieTitle < $1.movieTitle }
            case .ratings:
                return collections.sorted { $0.ratings < $1.ratings }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: Constants.SpacerNone) {
                VStack {
                    Picker("Sort By", selection: $sortOption) {
                        Text("Title").tag(SortOption.movieTitle)
                        Text("Rating").tag(SortOption.ratings)
                        // if UserInterfaceSizeClass.compact != horizontalSizeClass {
                        //     Text("Location").tag(SortOption.locations)
                        // }
                    }
                    .pickerStyle(.segmented)
                    .labelStyle(.automatic)
                    .padding(.leading, Constants.SpacerMedium)
                    .padding(.trailing, Constants.SpacerMedium)
                    .padding(.bottom, Constants.SpacerNone)
                    .disabled(collections.isEmpty)
                }
                List {
                    if !collections.isEmpty {
                        ForEach(sortedCollections) { collection in
                            NavigationLink(destination: MovieDetail(movieCollection: collection)) {
                                MovieRowView(movieCollection: collection)
                            }
                            .listRowBackground(Color.transparent)
                            .listRowSeparator(Visibility.visible, edges: .bottom)
                        }
                        .onDelete(perform: deleteItems)
                    } else {
                        Label("There are no movies in your collection.", systemImage: "list.and.film")
                            .padding()
                    }
                }
                .padding(.horizontal, Constants.SpacerNone)
                .padding(.vertical, Constants.SpacerNone)
                .scrollContentBackground(.hidden) // Hides the background content of the scrollable area
                .navigationTitle("Movies: \(collections.count)") // Adds a summary count to the page title of the total items in the collections list
                .navigationBarTitleDisplayMode(.large)
                .toolbarBackground(.hidden)
                .toolbar {
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
                    }
                    ToolbarItemGroup(placement: .primaryAction) {
                        Button(action: addCollection) {
                            Label("Add Movie", systemImage: "plus.app")
                                .foregroundStyle(.white)
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
            let newItem = MovieCollection(id: UUID(), movieTitle: "", ratings: "Unrated", genre: "Other", releaseDate: .now, purchaseDate: .now, locations: "None", enteredDate: .now)
            modelContext.insert(newItem)
            newCollection = newItem
        }
    }

    private func createCSVFile() -> URL? {
        let headers = "Title,Ratings,Genre,Release Date,PurchaseDate,Locations,EnteredDate\n"
        let rows = collections.map { Record(movieTitle: $0.movieTitle, ratings: $0.ratings, genre: $0.genre, releaseDate: $0.releaseDate, purchaseDate: $0.purchaseDate, locations: $0.locations, enteredDate: $0.enteredDate).toCSV() }.joined(separator: "\n")
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

#Preview("Movie List") {
    MovieList() // Simplified Preview
        .navigationTitle("Movie List")
        .navigationBarTitleDisplayMode(.inline)
        .modelContainer(for: MovieCollection.self, inMemory: false)
        .background(Gradient(colors: transparentGradient))
}

#Preview("Empty List") {
    MovieList() // Simplified Preview
        .navigationTitle("Empty")
        .navigationBarTitleDisplayMode(.inline)
        .modelContainer(for: MovieCollection.self, inMemory: true)
        .background(Gradient(colors: transparentGradient))
}
