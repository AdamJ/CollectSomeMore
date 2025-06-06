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

    // --- New @AppStorage for selected grouping option ---
    @AppStorage("gameGroupingOption")
    private var selectedGroupingOption: GameGroupingOption = .gameTitle // Default grouping
    // --- End New @AppStorage ---
    
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
    // Added availableGenres as an assumption for the .genre grouping option
    private var availableGenres: Set<String> {
        Set(collections.compactMap { $0.genre })
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

    // --- Updated groupedCollections Computed Property ---
    private var groupedCollections: [GameCollectionSection] {
        guard !filteredAndSearchedCollections.isEmpty else {
            return []
        }

        let groupedDictionary: [String: [GameCollection]]

        switch selectedGroupingOption {
        case .gameTitle:
            // Group by first letter, with '#' for non-letters
            groupedDictionary = Dictionary(grouping: filteredAndSearchedCollections) { collection in
                let title = collection.gameTitle ?? ""
                let firstCharacter = title.first?.uppercased() ?? "#"
                let isLetter = firstCharacter.rangeOfCharacter(from: .letters) != nil
                return isLetter ? firstCharacter : "#"
            }
        case .brand:
            groupedDictionary = Dictionary(grouping: filteredAndSearchedCollections) { $0.brand ?? "Unknown Brand" }
        case .system:
            groupedDictionary = Dictionary(grouping: filteredAndSearchedCollections) { $0.system ?? "Unknown Console" }
        case .locations:
            groupedDictionary = Dictionary(grouping: filteredAndSearchedCollections) { $0.locations ?? "Unknown Location" }
        case .genre:
            groupedDictionary = Dictionary(grouping: filteredAndSearchedCollections) { $0.genre ?? "Unknown Genre" }
        }

        // Sort keys. Handles '#' for .gameTitle, otherwise alphabetical.
        let sortedKeys = groupedDictionary.keys.sorted { key1, key2 in
            if selectedGroupingOption == .gameTitle {
                if key1 == "#" { return false } // # comes after all letters
                if key2 == "#" { return true }  // # comes after all letters
            }
            return key1 < key2                  // Sort other keys alphabetically
        }

        return sortedKeys.map { key in
            let itemsInSection = groupedDictionary[key]!
            // Always sort items within each section by gameTitle for consistency
            let sortedItems = itemsInSection.sorted { item1, item2 in
                (item1.gameTitle ?? "") < (item2.gameTitle ?? "")
            }
            return GameCollectionSection(id: key, items: sortedItems)
        }
    }
    // --- End Updated groupedCollections ---

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: Sizing.SpacerNone) {
                if games.isEmpty {
                    // Content for empty games array
                } else {
                    ZStack {
                        HStack {
                            HStack(spacing: Sizing.SpacerMedium) {
                                Menu {
                                    Picker("Brand", selection: $filterBrand) {
                                        ForEach(GameBrands.brands, id: \.self) { brand in
                                            Text(brand)
                                                .tag(brand)
                                                .disabled(!availableBrands.contains(brand) && brand != "Brand")
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    Picker("System", selection: $filterSystem) {
                                        ForEach(GameSystems.systems, id: \.self) { system in
                                            Text(system)
                                                .tag(system)
                                                .disabled(!availableSystems.contains(system) && system != "Consoles")
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
                                .disabled(games.isEmpty)
                                .menuStyle(FilterMenuStyle())
                            }
                            
                            // --- New Group By Picker ---
                            Menu {
                                Picker("\(selectedGroupingOption)", selection: $selectedGroupingOption) {
                                    ForEach(GameGroupingOption.allCases) { option in
                                        Text(option.displayName).tag(option)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text("Group by \(selectedGroupingOption.displayName)")
                                }
                                .foregroundStyle(Color.white) // Adjust text color as needed
                                    .captionStyle() // Apply your custom style
                            }
                            .disabled(games.isEmpty)
                            .menuStyle(FilterMenuStyle()) // Apply your custom menu style
                            // --- End New Group By Picker ---

                            Spacer()

                            if isFilterActive {
                                Button("Reset") {
                                    searchGamesText = ""
                                    filterSystem = "All" // Reset to default value
                                    filterLocation = "All" // Reset to default value
                                    filterBrand = "Any"
                                }
                                .foregroundStyle(Colors.onSurface)
                            }
                        }
                        .padding(.top, Sizing.SpacerSmall)
                        .padding(.bottom, Sizing.SpacerSmall)
                        .padding(.horizontal)
                        .background(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: .secondaryContainer.opacity(1.0), location: 0.00),
                                    Gradient.Stop(color: .secondaryContainer.opacity(0.75), location: 0.75),
                                    Gradient.Stop(color: .secondaryContainer.opacity(0.50), location: 1.00),
                                ],
                                startPoint: UnitPoint(x: 0.5, y: -0.12),
                                endPoint: UnitPoint(x: 0.5, y: 1)
                            )
                        )
                        .colorScheme(.dark)
                    }
                    .background(Colors.primaryMaterial)
                }
                
                if games.isEmpty {
                    ContentUnavailableView {
                        Label("There are no games to show", systemImage: "xmark.bin")
                            .padding()
                            .titleStyle()
                        Text("Add games to start building your collection.")
                            .bodyStyle()
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .navigationTitle("Games (\(filteredAndSearchedCollections.count) / \(games.count))")
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
                        VStack {
                            Image(systemName: "xmark.bin")
                                .foregroundColor(.secondary)
                                .font(.system(size: 72))
                                .multilineTextAlignment(.center)
                            Text("No games match your criteria")
                                .padding()
                                .title2Style()
                            Text("Try adjusting your filters")
                                .subtitleStyle()
                            VStack {
                                HStack(alignment: .center, spacing: Sizing.SpacerNone) { // Chip
                                    HStack(alignment: .center, spacing: Sizing.SpacerSmall) { // State Layer
                                        Text("Brand: \(filterBrand)")
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
                                
                                HStack(alignment: .center, spacing: Sizing.SpacerNone) { // Chip
                                    HStack(alignment: .center, spacing: Sizing.SpacerSmall) { // State Layer
                                        Text("System: \(filterSystem)")
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
                    .navigationTitle("Games (\(filteredAndSearchedCollections.count) / \(games.count))")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbarBackground(Colors.secondaryContainer, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarColorScheme(.dark)
                    .toolbar {
                        ToolbarItemGroup(placement: .primaryAction) {
                            Button(action: addCollection) {
                                Label("Add Game", systemImage: "plus.app")
                                    .labelStyle(.iconOnly)
                            }
                            .disabled(filteredAndSearchedCollections.isEmpty)
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
                                            Label(collection.isPlayed ? "Mark Unplayed" : "Mark Played", systemImage: collection.isPlayed ? "seal.fill" : "checkmark.seal.fill")
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
                        .listRowSeparator(.hidden, edges: .all)
                        .listRowInsets(.init(top: Sizing.SpacerNone, leading: Sizing.SpacerSmall, bottom: Sizing.SpacerNone, trailing: Sizing.SpacerSmall))
                    }
//                    .listStyle(.plain)
                    .listSectionSpacing(.compact)
                    .background(Colors.surfaceContainerLow)  // list background
                    .scrollContentBackground(.hidden) // allows custom background to show through
                    .navigationTitle("Games (\(filteredAndSearchedCollections.count) / \(games.count))")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbarBackground(Colors.secondaryContainer, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarColorScheme(.dark)
                    .toolbar {
                        ToolbarItemGroup(placement: .primaryAction) {
                            Button(action: addCollection) {
                                Label("Add Game", systemImage: "plus.app")
                                    .labelStyle(.iconOnly)
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
                            EditButton()
                        }
                        if currentEditMode == .active {
                            ToolbarItemGroup(placement: .bottomBar) {
                                Button("Played") {
                                    showMarkPlayedConfirmation = true
                                }
                                .captionStyle()
                                .buttonStyle(.borderedProminent)
                                .disabled(selectedGameIDs.isEmpty || selectedGames.allSatisfy({ $0.isPlayed }))
                                .confirmationDialog("Mark the selected game(s) as played?", isPresented: $showMarkPlayedConfirmation, titleVisibility: .visible) {
                                    Button("Confirm") {
                                        markSelectedGames(played: true)
                                    }
                                    .bodyStyle()
                                    Button("Cancel", role: .cancel) {}
                                        .bodyStyle()
                                }

                                Spacer()

                                Button("Unplayed") {
                                    showMarkUnplayedConfirmation = true
                                }
                                .captionStyle()
                                .buttonStyle(.borderedProminent)
                                .disabled(selectedGameIDs.isEmpty || selectedGames.allSatisfy({ !$0.isPlayed }))
                                .confirmationDialog("Mark the selected game(s) as unplayed?", isPresented: $showMarkUnplayedConfirmation, titleVisibility: .visible) {
                                    Button("Confirm") {
                                        markSelectedGames(played: false)
                                    }
                                    .bodyStyle()
                                    Button("Cancel", role: .cancel) {}
                                        .bodyStyle()
                                }

                                Spacer()

                                Button(role: .destructive) {
                                    showDeleteConfirmation = true
                                } label: {
                                    Text("Delete (\(selectedGameIDs.count))")
                                        .captionStyle()
                                        .foregroundStyle(.red)
                                }
                                .disabled(selectedGameIDs.isEmpty)
                                .confirmationDialog("Delete the selected game(s)?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
                                    Button("Delete", role: .destructive) {
                                        deleteSelectedGames()
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
                    selectedGameIDs.removeAll()
                }
            }
        }
        .searchable(
            text: $searchGamesText,
            placement: .automatic,
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

    private func deleteSelectedGames() {
        for gameID in selectedGameIDs {
            if let gameToDelete = games.first(where: { $0.id == gameID }) {
                modelContext.delete(gameToDelete)
            }
        }
        selectedGameIDs.removeAll() // Clear selection after deletion
        currentEditMode = .inactive // Set State to inactive after performing action
    }

    private func markSelectedGames(played: Bool) {
        for gameID in selectedGameIDs {
            if let gameToUpdate = games.first(where: { $0.id == gameID }) {
                gameToUpdate.isPlayed = played
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

#Preview("Game List View") {
    GameListView()
        .modelContainer(GameData.shared.modelContainer) // Assuming GameData and modelContainer are set up
}
#Preview("Game List View with Sample Data") {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: GameCollection.self, configurations: config)

        // Directly reference the static sample data from GameCollection
        @MainActor func insertSampleData() {
            for game in GameCollection.sampleGameCollectionData { // <-- Reference like this!
                container.mainContext.insert(game)
            }
        }
        insertSampleData()

        return GameListView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create ModelContainer for preview: \(error)")
    }
}
