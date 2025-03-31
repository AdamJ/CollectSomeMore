//
//  GameListView.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/26/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI
import SwiftData

struct GameListView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Query(sort: \GameCollection.gameTitle) private var collections: [GameCollection]

    enum SortOption {
        case gameTitle, console, locations
    }

    @State private var newCollection: GameCollection?
    @State private var selectedItem: Int = 0
    @State private var sortOption: SortOption = .gameTitle
    @State private var showingExportSheet = false
    @State private var showingAlert = false
    @State private var alertMessage = ""

    struct Record { // Moved Record struct inside GameListView for now
        var collectionState: String
        var gameTitle: String
        var console: String
        var genre: String
        var purchaseDate: Date
        var locations: String
        var notes: String
        var enteredDate: Date

        init(collectionState: String, gameTitle: String, console: String, genre: String, purchaseDate: Date, locations: String, notes: String?, enteredDate: Date) {
            self.collectionState = collectionState
            self.gameTitle = gameTitle
            self.console = console
            self.genre = genre
            self.purchaseDate = purchaseDate
            self.locations = locations
            self.notes = notes ?? ""
            self.enteredDate = enteredDate
        }

        func toCSV() -> String {
            return "\(collectionState),\(gameTitle),\(console),\(genre),\(purchaseDate),\(locations),\(notes),\(enteredDate)"
        }
    }

    var sortedCollections: [GameCollection] {
        switch sortOption {
            case .gameTitle:
                return collections.sorted { $0.gameTitle ?? "" < $1.gameTitle ?? "" }
            case .console:
                return collections.sorted { $0.console ?? "" < $1.console ?? "" }
            case .locations:
                return collections.sorted { $0.locations ?? "" < $1.locations ?? "" }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: Constants.SpacerNone) {
                VStack {
                    Picker("Sort By", selection: $sortOption) {
                        Text("Title").tag(SortOption.gameTitle)
                        Text("Console").tag(SortOption.console)
                         if UserInterfaceSizeClass.compact != horizontalSizeClass {
                             Text("Location").tag(SortOption.locations)
                         }
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
                            NavigationLink(destination: GameDetailView(gameCollection: collection)) {
                                GameRowView(gameCollection: collection)
                            }
                            .listRowBackground(Color.transparent)
                            .listRowSeparator(Visibility.visible, edges: .bottom)
                        }
                        .onDelete(perform: deleteItems)
                    } else {
                        Label("There are no games in your collection.", systemImage: "gamecontroller") // Updated message
                            .padding()
                    }
                }
                .padding(.horizontal, Constants.SpacerNone)
                .padding(.vertical, Constants.SpacerNone)
                .scrollContentBackground(.hidden) // Hides the background content of the scrollable area
                .navigationTitle("Games (\(collections.count))") // Adds a summary count to the page title of the total items in the collections list
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
                            Label("Add Game", systemImage: "plus.app")
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
                    GameDetailView(gameCollection: collection, isNew: true)
                }
            }
            .interactiveDismissDisabled()
        }
    }

    private func addCollection() {
        withAnimation {
            let newItem = GameCollection(id: UUID(), collectionState: "", gameTitle: "", console: "None", genre: "Other", purchaseDate: .now, locations: "None", notes: "", enteredDate: .now)
            newCollection = newItem // Simply create the new item and assign it to trigger the sheet
        }
    }

    private func createCSVFile() -> URL? {
        let headers = "CollectionState,Title,Console,Genre,PurchaseDate,Locations,Notes,EnteredDate\n"
        let rows = collections.map { Record(collectionState: $0.collectionState ?? "", gameTitle: $0.gameTitle ?? "", console: $0.console ?? "", genre: $0.genre ?? "", purchaseDate: $0.purchaseDate ?? Date(), locations: $0.locations ?? "", notes: $0.notes, enteredDate: $0.enteredDate ?? Date()).toCSV() }.joined(separator: "\n")
        let csvContent = headers + rows

        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            alertMessage = "Could not access documents directory"
            showingAlert = true
            return nil
        }

        let fileName = "Game_Collection_Backup_\(Date().timeIntervalSince1970).csv"
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
