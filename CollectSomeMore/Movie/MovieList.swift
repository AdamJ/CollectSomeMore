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
    @Query(sort: \Collection.title) private var collections: [Collection]

    enum SortOption {
        case title, ratings
    }
    
    @State private var newCollection: Collection?
    @State private var selectedItem: Int = 0
    @State private var sortOption: SortOption = .title
    @State private var showingExportSheet = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    struct Record {
        var title: String
        var releaseDate: Date
        var purchaseDate: Date
        var genre: String
        var ratings: String
        var locations: String

        init(title: String, releaseDate: Date, purchaseDate: Date, genre: String, ratings: String, locations: String) {
            self.title = title
            self.releaseDate = releaseDate
            self.purchaseDate = purchaseDate
            self.genre = genre
            self.ratings = ratings
            self.locations = locations
        }

        func toCSV() -> String {
            return "\(title),\(releaseDate),\(purchaseDate),\(genre),\(ratings),\(locations)"
        }
    }
    
    let isNew: Bool
    
    init(collection: Collection, isNew: Bool = false) {
        self.collection = collection
        self.isNew = isNew
    }

    var sortedCollections: [Collection] {
        switch sortOption {
            case .title:
                return collections.sorted { $0.title < $1.title }
            case .ratings:
                return collections.sorted { $0.ratings < $1.ratings }
        }
    }
    
    var body: some View {
        NavigationStack {
            Picker("Sort By", selection: $sortOption) {
                Text("Title").tag(SortOption.title)
                Text("Rating").tag(SortOption.ratings)
            }.pickerStyle(SegmentedPickerStyle())
            Group {
                if !collections.isEmpty {
                    List {
                        ForEach(sortedCollections) { collection in
                            NavigationLink(destination: MovieDetail(collection: collection)) {
                                MovieRowView(collection: collection)
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .navigationTitle("Movies")
                    .navigationBarTitleDisplayMode(.automatic)
                    .toolbar {
                        ToolbarItemGroup(placement: .primaryAction) {
                            EditButton()
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
                            Button(action: addCollection) {
                                Label("Add Movie", systemImage: "plus.app")
                            }
                        }
                    }
                } else {
                    ContentUnavailableView {
                        Label("There are no movies in your collection.", systemImage: "list.and.film")
                        Button("Add a movie", action: addCollection)
                            .buttonStyle(.borderedProminent)
                            .foregroundStyle(.background)
                    }
                }
            }
        }
        .sheet(item: $newCollection) { collection in
            NavigationStack {
                MovieDetail(collection: collection, isNew: true)
            }
            .interactiveDismissDisabled()
        }
    }

    private func addCollection() {
        withAnimation {
            let newItem = Collection(id: UUID(), title: "", releaseDate: .now, purchaseDate: Date(timeIntervalSinceNow: -5_000_000), genre: "Action", ratings: "R", locations: "Cabinet")
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
        let headers = "Title,Release Date,PurchaseDate,Genere,Ratings,Locations\n"
        let rows = collections.map { Record(title: $0.title, releaseDate: $0.releaseDate, purchaseDate: $0.purchaseDate, genre: $0.genre, ratings: $0.ratings, locations: $0.locations).toCSV() }.joined(separator: "\n")
        let csvContent = headers + rows
        
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            alertMessage = "Could not access documents directory"
            showingAlert = true
            return nil
        }
        
        let fileName = "Movie_List_Backup_\(Date().timeIntervalSince1970).csv"
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

#Preview("Data List") {
    MovieList(collection: CollectionData.shared.collection)
        .navigationTitle("Data List")
        .navigationBarTitleDisplayMode(.inline)
        .modelContainer(for: Collection.self, inMemory: false)
}

#Preview("Empty List") {
    MovieList(collection: CollectionData.shared.collection)
        .navigationTitle("Empty")
        .navigationBarTitleDisplayMode(.inline)
        .modelContainer(for: Collection.self, inMemory: true)
}
