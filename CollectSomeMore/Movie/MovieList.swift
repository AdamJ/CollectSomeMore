//
//  MovieList.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 10/8/24.
//

import SwiftUI
import SwiftData

struct MovieList: View {
    @Bindable var collection: Collection
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Query(sort: \Collection.movieTitle) private var collections: [Collection]

    enum SortOption {
        case movieTitle, ratings, locations
    }
    
    @State private var movieTitle: [String] = []
    @State private var newCollection: Collection?
    @State private var selectedItem: Int = 0
    @State private var sortOption: SortOption = .movieTitle
    @State private var showingExportSheet = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    struct Record {
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
    
    let isNew: Bool
    
    init(collection: Collection, isNew: Bool = false) {
        self.collection = collection
        self.isNew = isNew
    }

    var sortedCollections: [Collection] {
        switch sortOption {
            case .movieTitle:
                return collections.sorted { $0.movieTitle < $1.movieTitle }
            case .ratings:
                return collections.sorted { $0.ratings < $1.ratings }
            case .locations:
                return collections.sorted { $0.locations < $1.locations }
        }
    }
// Placeholder - to be added later
//    var filteredCollections: [Collection] {
//        guard !title.isEmpty else {
//            return sortedCollections
//        }
//        return sortedCollections.filter {
//            title.contains($0.title)
//        }
//    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: Constants.SpacerNone) {
                if !collections.isEmpty {
                    VStack {
                        Picker("Sort By", selection: $sortOption) {
                            Text("Title").tag(SortOption.movieTitle)
                            Text("Rating").tag(SortOption.ratings)
                            if UserInterfaceSizeClass.compact != horizontalSizeClass {
                                Text("Location").tag(SortOption.locations)
                            }
                        }
                        .pickerStyle(.segmented)
                        .labelStyle(.automatic)
                        .padding(.leading, Constants.SpacerMedium)
                        .padding(.trailing, Constants.SpacerMedium)
                        .padding(.bottom, Constants.SpacerNone)
                    }
                    List {
                        ForEach(sortedCollections) { collection in
                            NavigationLink(destination: MovieDetail(collection: collection)) {
                                MovieRowView(collection: collection)
                            }
                            .listRowBackground(Color.transparent)
                            .listRowSeparator(Visibility.visible, edges: .bottom)
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .padding(.horizontal, Constants.SpacerNone)
                    .padding(.vertical, Constants.SpacerNone)
                    .scrollContentBackground(.hidden) // Hides the background content of the scrollable area
                    .navigationTitle("Movies: \(collections.count)") // Adds a summary count to the page title of the total items in the collections list
                    .navigationBarTitleDisplayMode(.large)
                    .toolbarBackground(.hidden)
                    .toolbar {
                        ToolbarItemGroup(placement: .secondaryAction) {
                            //                            EditButton()
                            Button("Export", systemImage: "square.and.arrow.up") {
                                if createCSVFile() != nil {
                                    showingExportSheet = true
                                }
                            }
                            .sheet(isPresented: $showingExportSheet) {
                                ShareSheet(activityItems: [createCSVFile()].compactMap { $0 })
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
                    }
                } else {
                    VStack {
                        Picker("Sort By", selection: $sortOption) {
                            Text("Title").tag(SortOption.movieTitle)
                            Text("Rating").tag(SortOption.ratings)
                            Text("Location").tag(SortOption.locations)
                        }
                        .pickerStyle(.segmented)
                        .labelStyle(.automatic)
                        .disabled(true) // I still want to show the toolbar, so I just disable it
                        .padding(.leading, Constants.SpacerMedium)
                        .padding(.trailing, Constants.SpacerMedium)
                        .padding(.bottom, Constants.SpacerNone)
                    }
                    List {
                        Label("There are no movies in your collection.", systemImage: "list.and.film")
                            .padding()
                    }
                    .scrollContentBackground(.hidden) // Hides the background content of the scrollable area
                    .navigationTitle("Movies: \(collections.count)") // Adds a summary count to the page title of the total items in the collections list
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.hidden)
                    .toolbar {
                        ToolbarItemGroup(placement: .primaryAction) {
                            Button(action: addCollection) {
                                Label("Add Movie", systemImage: "plus.app")
                                    .labelStyle(.titleAndIcon)
                            }
                        }
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
                    MovieDetail(collection: collection, isNew: true)
                }
            }
            .interactiveDismissDisabled()
        }
    }

    private func addCollection() {
        withAnimation {
            let newItem = Collection(id: UUID(), movieTitle: "", ratings: "Unrated", genre: "Other", releaseDate: .now, purchaseDate: .now, locations: "None", enteredDate: .now)
            modelContext.insert(newItem)
            newCollection = newItem
        }
    }

    private func exportToCSV() {
        if createCSVFile() != nil {
            showingExportSheet = true
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
    MovieList(collection: CollectionData.shared.collection)
        .navigationTitle("Movie List")
        .navigationBarTitleDisplayMode(.inline)
        .modelContainer(for: Collection.self, inMemory: false)
        .background(Gradient(colors: transparentGradient))
}

#Preview("Empty List") {
    MovieList(collection: CollectionData.shared.collection)
        .navigationTitle("Empty")
        .navigationBarTitleDisplayMode(.inline)
        .modelContainer(for: Collection.self, inMemory: true)
        .background(Gradient(colors: transparentGradient))
}
