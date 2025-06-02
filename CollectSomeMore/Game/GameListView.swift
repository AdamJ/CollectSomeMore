//
//  GameListView.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/26/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI
import SwiftData
import Foundation

struct GameCollectionSection: Identifiable {
    let id: String // The letter or '#'
    let items: [GameCollection]
}

struct GameListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.editMode) private var editMode
    
    @State private var currentEditMode: EditMode = .inactive
    
    @Query(sort: [SortDescriptor(\GameCollection.enteredDate, order: .reverse), SortDescriptor(\GameCollection.gameTitle)]) private var games: [GameCollection]

    enum SortOption: CustomStringConvertible {
        case gameTitle
        case brand
        case locations
        case system
        
        var description: String {
            switch self {
            case .gameTitle:
                return "Title"
            case .brand:
                return "Brand"
            case .locations:
                return "Location"
            case .system:
                return "Console"
            }
        }
    }

    @State private var newCollection: GameCollection?
    @State private var showingExportSheet = false
    @State private var showingAlert = false
    @State private var showingAddSheet = false
    @State private var alertMessage = ""
    @State private var searchGamesText: String = ""

    @State private var filterSystem: String = "All"
    @State private var filterLocation: String = "All"
    @State private var filterBrand: String = "Any"
    
    // MARK: - Multi-select state
        @State private var selectedGameIDs = Set<UUID>()
        @State private var showDeleteConfirmation = false
        @State private var showMarkPlayedConfirmation = false
        @State private var showMarkUnplayedConfirmation = false
    
    private var isFilterActive: Bool {
        !searchGamesText.isEmpty || // is searchText not empty?
        filterSystem != "All" || // is a System selected?
        filterLocation != "All" || // is a Location selected?
        filterBrand != "Any" // is a Brand selected?
    }
    
    private var collections: [GameCollection] {
        return games // Assumes 'collections' should be 'games'
    }

    private var availableSystems: Set<String> {
        Set(collections.compactMap { $0.system })
    }
    private var availableLocations: Set<String> {
        Set(collections.compactMap { $0.locations })
    }
    private var availableBrands: Set<String> {
        Set(collections.compactMap { $0.brand })
    }
    private var selectedGames: [GameCollection] {
            games.filter { selectedGameIDs.contains($0.id) }
        }

    struct Record {
        var collectionState: String
        var gameTitle: String
        var brand: String
        var system: String
        var genre: String
        var rating: String
        var purchaseDate: Date
        var locations: String
        var enteredDate: Date
        var notes: String = ""
        var isPlayed: Bool = false
        
        init(collectionState: String, gameTitle: String, brand: String, system: String, genre: String, rating: String, purchaseDate: Date, locations: String, enteredDate: Date, notes: String?, isPlayed: Bool = false) {
            self.collectionState = collectionState
            self.gameTitle = gameTitle
            self.brand = brand
            self.system = system
            self.genre = genre
            self.rating = rating
            self.purchaseDate = purchaseDate
            self.locations = locations
            self.enteredDate = enteredDate
            self.notes = notes ?? ""
            self.isPlayed = isPlayed
        }
        func toCSV() -> String {
            return "\(collectionState), \(gameTitle), \(brand), \(system), \(genre), \(rating), \(purchaseDate), \(locations), \(enteredDate), \(notes), \(isPlayed)"
        }
    }

    var filteredAndSearchedCollections: [GameCollection] {
        collections
            .filter { item in
                (filterBrand == "Any" || item.brand == filterBrand) &&
                (filterSystem == "All" || item.system == filterSystem) &&
                (filterLocation == "All" || item.locations == filterLocation) &&
                (searchGamesText.isEmpty || (item.gameTitle?.localizedStandardContains(searchGamesText) ?? true))
            }
    }

    private var groupedCollections: [GameCollectionSection] {
        guard !filteredAndSearchedCollections.isEmpty else {
            return []
        }

        let groupedDictionary = Dictionary(grouping: filteredAndSearchedCollections) { collection in
            let title = collection.gameTitle ?? ""
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
            let itemsInSection = groupedDictionary[key]!
            let sortedItems = itemsInSection.sorted { item1, item2 in
                (item1.gameTitle ?? "") < (item2.gameTitle ?? "")
            }
            return GameCollectionSection(id: key, items: sortedItems)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: Sizing.SpacerNone) {
                if collections.isEmpty {
                } else {
                    HStack {
                        Menu("Filter", systemImage: "line.3.horizontal.decrease.circle") {
                            Picker("Brand", selection: $filterBrand) {
                                ForEach(GameBrands.brands, id: \.self) { brand in
                                    Text(brand)
                                        .tag(brand)
                                        .disabled(!availableBrands.contains(brand) && brand != "Any")
                                }
                            }
                            .pickerStyle(.menu)
                            
                            Text("\(filterBrand)")
                            
                            Menu("Console") {
                                Picker("Console", selection: $filterSystem) {
                                    ForEach(GameSystems.systems, id: \.self) { system in
                                        Text(system)
                                            .tag(system)
                                            .disabled(!availableSystems.contains(system) && system != "All Consoles")
                                    }
                                }
                            }
                            .bodyStyle()
                            
                            Text("\(filterSystem)")
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
                
                if collections.isEmpty {
                    ContentUnavailableView {
                        Label("There are no games to show", systemImage: "xmark.bin")
                            .padding()
                            .titleStyle()
                        Text("Add games to start building your collection.")
                            .bodyStyle()
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .navigationTitle("Games (\(collections.count))")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbarBackground(Colors.primaryMaterial, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarColorScheme(.dark)
                    .toolbar {
                        ToolbarItemGroup(placement: .primaryAction) {
                            Button(action: addCollection) {
                                Label("Add Game", systemImage: "plus.app")
                            }
                        }
                    }
                } else if filteredAndSearchedCollections.isEmpty {
                    ContentUnavailableView {
                        Label("No games match your criteria", systemImage: "xmark.bin")
                            .padding()
                            .title2Style()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .navigationTitle("Games (\(collections.count))")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbarBackground(Colors.primaryMaterial, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarColorScheme(.dark)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            if isFilterActive {
                                Button("Reset") {
                                    // Set each filter state variable back to its default value
                                    searchGamesText = ""
                                    filterSystem = "All" // Reset to default value
                                    filterLocation = "All" // Reset to default value
                                    filterBrand = "Any"
                                }
                            }
                        }
                    }
                } else {
                    List(selection: $selectedGameIDs) {
                        ForEach(groupedCollections) { section in
                            Section(header: Text(section.id)) {
                                ForEach(section.items) { collection in
                                    NavigationLink(destination: GameDetailView(gameCollection: collection)) {
                                        GameRowView(gameCollection: collection)
                                    }
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            togglePlayedStatus(for: collection)
                                        } label: {
                                            Label(collection.isPlayed ? "Mark Unplayed" : "Mark Played", systemImage: collection.isPlayed ? "xmark.circle.fill" : "checkmark.circle.fill")
                                        }
                                        .tint(collection.isPlayed ? .orange : .green)
                                    }
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            deleteGame(collection)
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
//                    .refreshable {} // add back in once other aspects are set
                    .listSectionSpacing(.compact)
                    .background(Colors.surfaceContainerLow)  // list background
                    .scrollContentBackground(.hidden) // allows custom background to show through
                    .navigationTitle("Games (\(collections.count))")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbarBackground(Colors.primaryMaterial, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarColorScheme(.dark)
                    .toolbar {
                        ToolbarItemGroup(placement: .primaryAction) {
                            Button(action: addCollection) {
                                Label("Add Game", systemImage: "plus.app")
                                    .labelStyle(.titleAndIcon)
                            }
                            EditButton()
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
                                if let fileURL = createGameCSVFile() {
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
                            if isFilterActive {
                                Button("Reset") {
                                    searchGamesText = ""
                                    filterSystem = "All" // Reset to default value
                                    filterLocation = "All" // Reset to default value
                                    filterBrand = "Any"
                                }
                            }
                        }
                        if currentEditMode == .active {
                            ToolbarItemGroup(placement: .bottomBar) {
                                Button("Mark Played") {
                                    showMarkPlayedConfirmation = true
                                }
                                .disabled(selectedGameIDs.isEmpty || selectedGames.allSatisfy({ $0.isPlayed }))
                                .confirmationDialog("Mark Selected Games as Played?", isPresented: $showMarkPlayedConfirmation, titleVisibility: .visible) {
                                    Button("Mark Played") {
                                        markSelectedGames(played: true)
                                    }
                                    Button("Cancel", role: .cancel) {}
                                }

                                Spacer()

                                Button("Mark Unplayed") {
                                    showMarkUnplayedConfirmation = true
                                }
                                .disabled(selectedGameIDs.isEmpty || selectedGames.allSatisfy({ !$0.isPlayed }))
                                .confirmationDialog("Mark Selected Games as Unplayed?", isPresented: $showMarkUnplayedConfirmation, titleVisibility: .visible) {
                                    Button("Mark Unplayed") {
                                        markSelectedGames(played: false)
                                    }
                                    Button("Cancel", role: .cancel) {}
                                }

                                Spacer()

                                Button(role: .destructive) {
                                    showDeleteConfirmation = true
                                } label: {
                                    Text("Delete (\(selectedGameIDs.count))")
                                }
                                .disabled(selectedGameIDs.isEmpty)
                                .confirmationDialog("Delete Selected Games?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
                                    Button("Delete", role: .destructive) {
                                        deleteSelectedGames()
                                    }
                                    Button("Cancel", role: .cancel) {}
                                }
                            }
                        }
                    }
                }
            }
            .padding(.all, Sizing.SpacerNone)
            // Bind the explicit editMode state to the environment for the List
            .environment(\.editMode, $currentEditMode)
            // Listen for changes in editMode to clear selection when exiting edit mode
            .onChange(of: currentEditMode) { oldValue, newValue in
                if newValue == .inactive {
                    selectedGameIDs.removeAll()
                }
            }
        }
        .searchable(
            text: $searchGamesText,
            placement: .navigationBarDrawer(displayMode: .automatic),
            prompt: "Search game collection"
        )
        .bodyStyle()
        .sheet(item: $newCollection) { collection in
            NavigationStack {
                VStack {
                    GameDetailView(gameCollection: collection, isNew: true)
                }
            }
            .interactiveDismissDisabled()
        }
        
        .onAppear {
            filterSystem = "All"
            filterLocation = "All"
            filterBrand = "Any"
        }
    }

    private func addCollection() {
        withAnimation {
            let newItem = GameCollection(id: UUID(), collectionState: "Owned", gameTitle: "", brand: "None", system: "None", rating: "Unknown", genre: "Other", purchaseDate: .now, locations: "None", notes: "", enteredDate: .now, isPlayed: false)
            newCollection = newItem
        }
    }
    
    private func deleteGame(_ game: GameCollection) {
        modelContext.delete(game)
    }
    
    private func togglePlayedStatus(for game: GameCollection) {
        game.isPlayed.toggle()
    }

    // MARK: - Bulk Actions
    private func deleteSelectedGames() {
        // Iterate over the IDs in the selectedGameIDs Set
        for gameID in selectedGameIDs {
            // Find the actual GameCollection object in your @Query games array
            if let gameToDelete = games.first(where: { $0.id == gameID }) {
                modelContext.delete(gameToDelete)
            }
        }
        selectedGameIDs.removeAll() // Clear selection after deletion
        currentEditMode = .inactive // Set State to inactive after performing action
    }

    // New function for bulk marking played status
    private func markSelectedGames(played: Bool) {
        // Iterate over the IDs in the selectedGameIDs Set
        for gameID in selectedGameIDs {
            // Find the actual GameCollection object in your @Query games array
            if let gameToUpdate = games.first(where: { $0.id == gameID }) {
                gameToUpdate.isPlayed = played // Now you can mutate its property
            }
        }
        selectedGameIDs.removeAll() // Clear selection after action
        currentEditMode = .inactive // Set State to inactive after performing action
    }
    
    private func createGameCSVFile() -> URL? {
        let headers = "Collection State,Title,Brand,System,Genre,Rating,Purchase Date,Location,Notes,Date Entered\n"
        let rows = collections.map { Record(collectionState: $0.collectionState ?? "", gameTitle: $0.gameTitle ?? "", brand: $0.brand ?? "", system: $0.system ?? "", genre: $0.genre ?? "", rating: $0.rating ?? "", purchaseDate: $0.purchaseDate ?? Date(), locations: $0.locations ?? "", enteredDate: $0.enteredDate ?? Date(), notes: $0.notes).toCSV() }.joined(separator: "\n")
        let csvContent = headers + rows

        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            alertMessage = "Could not access documents directory"
            showingAlert = true
            return nil
        }

        let fileName = "Game_Collection_Backup_\(Int(Date().timeIntervalSince1970)).csv"
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

// MARK: - GameCollection must be Hashable for Set<GameCollection>
extension GameCollection: Hashable {
    public static func == (lhs: GameCollection, rhs: GameCollection) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
}

#Preview("Game List View") {
    GameListView()
        .modelContainer(GameData.shared.modelContainer) // Assuming GameData and modelContainer are set up
}
