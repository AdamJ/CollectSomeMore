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
    let items: [CD_GameCollection]
}

struct GameListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.editMode) private var editMode
    
    @State private var currentEditMode: EditMode = .inactive
    @State private var showSearchBar = false
    
    @FocusState private var searchBarIsFocused: Bool
    
    @Query(sort: [SortDescriptor(\CD_GameCollection.enteredDate, order: .reverse), SortDescriptor(\CD_GameCollection.gameTitle)]) private var games: [CD_GameCollection]
    
    @AppStorage("gameGroupingOption")
    private var selectedGroupingOption: GameGroupingOption = .gameTitle
    
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

    @State private var newCollection: CD_GameCollection?
    @State private var activeGameForNavigation = NavigationPath()
    @State private var showingExportSheet = false
    @State private var showingAlert = false
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
    private var collections: [CD_GameCollection] {
        return games
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
    private var availableGenres: Set<String> {
        Set(collections.compactMap { $0.genre })
    }
    private var selectedGames: [CD_GameCollection] {
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

    var filteredAndSearchedCollections: [CD_GameCollection] {
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

        let groupedDictionary: [String: [CD_GameCollection]]

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

    @ViewBuilder
    private var gameListToolbar: some View {
        if games.isEmpty {
            // Content for empty games array
        } else {
            ZStack {
                VStack {
                    HStack {
                        HStack {
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
                                    Image(systemName: "line.3.horizontal.decrease")
                                    Text("Filters")
                                }
                                .foregroundStyle(Color.white)
                                .captionStyle()
                            }
                            .disabled(games.isEmpty)
                            .menuStyle(FilterMenuStyle())
                        }
                    
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
                            .foregroundStyle(Color.white)
                            .captionStyle()
                        }
                        .disabled(games.isEmpty)
                        .menuStyle(FilterMenuStyle())
                        
                        Spacer()
                        
                        if isFilterActive {
                            Button("Reset") {
                                searchGamesText = ""
                                filterSystem = "All"
                                filterLocation = "All"
                                filterBrand = "Any"
                            }
                            .foregroundStyle(Colors.onSurface)
                        }

                        Button {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                showSearchBar.toggle()
                            }
                            if !showSearchBar {
                                searchBarIsFocused = false
                                searchGamesText = ""
                            }
                        } label: {
                            if UIDevice.current.userInterfaceIdiom == .pad {
                                Text(showSearchBar ? "Cancel" : "Search")
                            }
                            Image(systemName: showSearchBar ? "xmark" : "magnifyingglass")
                        }
                        .padding(.vertical, Sizing.SpacerXSmall)
                        .padding(.horizontal, Sizing.SpacerSmall)
                        .background(Color.gray05.opacity(0.2))
                        .foregroundStyle(Color.white)
                        .captionStyle()
                        .clipShape(RoundedRectangle(cornerRadius: Sizing.SpacerMedium))
                    }
                    .padding(.top, Sizing.SpacerSmall)
                    .padding(.bottom, Sizing.SpacerSmall)
                    .padding(.horizontal)
                    .background(.secondaryContainer)
                    .colorScheme(.dark)
                    if showSearchBar {
                        CustomSearchBar(searchText: $searchGamesText, placeholder: "Search games...", isFocused: _searchBarIsFocused)
                            .transition(.move(edge: .trailing))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    searchBarIsFocused = true
                                }
                            }
                            .padding(.bottom, Sizing.SpacerSmall)
                            .background(.secondaryContainer)
                            .colorScheme(.dark)
                    }
                }
            }
            .background(.secondaryContainer)
            .colorScheme(.dark)
        }
    }

    @ViewBuilder
    private var gameEmptyContent: some View {
        ContentUnavailableView {
            Label("Empty Game Collection", systemImage: "xmark.bin")
                .padding()
                .titleStyle()
            Text("Add games to start building your collection.")
                .bodyStyle()
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Colors.surfaceLevel)
        .scrollContentBackground(.hidden)
        .navigationTitle("Games (\(filteredAndSearchedCollections.count) / \(games.count))")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(Colors.secondaryContainer, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button(action: addCollection) {
                    Label("Add Game", systemImage: "plus.app")
                }
            }
        }
    }
    
    @ViewBuilder
    private var gameFilteredEmpty: some View {
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
                    HStack(alignment: .center, spacing: 0) {
                        HStack(alignment: .center, spacing: Sizing.SpacerSmall) {
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
                    
                    HStack(alignment: .center, spacing: 0) {
                        HStack(alignment: .center, spacing: Sizing.SpacerSmall) {
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
        .background(Colors.surfaceLevel)
        .scrollContentBackground(.hidden)
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
            ToolbarItem(placement: .secondaryAction) {
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
    }
    
    @ViewBuilder
    private var gameMainContent: some View {
        List(selection: $selectedGameIDs) {
            ForEach(groupedCollections) { section in
                Section {
                    ForEach(section.items) { game in
                        NavigationLink(value: game) {
                            GameRowView(gameCollection: game)
                        }
                        .tint(editMode?.wrappedValue == .active ? Colors.accent : nil)
                        .listRowBackground(
                            selectedGameIDs.contains(game.id) ?
                            Colors.accent.opacity(0.2) : Colors.surfaceLevel
                        )
                        .swipeActions(edge: .leading) {
                            Button {
                                togglePlayedStatus(for: game)
                            } label: {
                                Label(game.isPlayed ? "Mark Unplayed" : "Mark Played", systemImage: game.isPlayed ? "seal.fill" : "checkmark.seal.fill")
                            }
                            .tint(game.isPlayed ? .gray : .blue)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                deleteGame(game)
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
                } header: {
                    VStack(alignment: .center) {
                        Text(section.id)
                            .padding(.vertical, 0)
                            .padding(.horizontal, Sizing.SpacerXSmall)
                            .background(Color.backgroundGameColor(forSectionID: section.id))
                            .foregroundColor(Color.foregroundGameColor(forSectionID: section.id))
                            .minimalStyle()
                            .fontWeight(.bold)
                    }
                    .cornerRadius(Sizing.SpacerXSmall)
                }
                .minimalStyle()
            }
            .listRowSeparator(.hidden, edges: .all)
            .listRowInsets(.init(top: 0, leading: Sizing.SpacerSmall, bottom: 0, trailing: Sizing.SpacerSmall))
        }
        .listStyle(.plain)
        .listSectionSpacing(.compact)
        .background(Colors.surfaceLevel)
        .scrollContentBackground(.hidden)
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
    
    var body: some View {
        NavigationStack(path: $activeGameForNavigation) {
            VStack(alignment: .leading, spacing: Sizing.SpacerNone) {
                gameListToolbar
                if games.isEmpty {
                    gameEmptyContent
                } else if filteredAndSearchedCollections.isEmpty {
                    gameFilteredEmpty
                } else {
                    gameMainContent
                }
            }
            .padding(.all, 0)
            .environment(\.editMode, $currentEditMode)
            .onChange(of: currentEditMode) { oldValue, newValue in
                if newValue == .inactive {
                    selectedGameIDs.removeAll()
                }
            }
            .navigationDestination(for: CD_GameCollection.self) { game in
                GameDetailView(gameCollection: game)
                    .onDisappear {
                        activeGameForNavigation = NavigationPath()
                    }
            }
        }
        .bodyStyle()
        .background(Colors.surfaceLevel)
        .sheet(item: $newCollection) { collection in
            NavigationStack {
                GameDetailView(gameCollection: collection, isNew: true)
            }
            .interactiveDismissDisabled()
            .presentationDetents([.large])
            .onDisappear {}
        }
        
        .onAppear {
            filterSystem = "All"
            filterLocation = "All"
            filterBrand = "Any"
            activeGameForNavigation = NavigationPath()
            selectedGameIDs.removeAll()
        }
    }

    private func addCollection() {
        withAnimation {
            let newItem = CD_GameCollection(id: UUID(), collectionState: "Owned", gameTitle: "", brand: "None", system: "None", rating: "Unknown", genre: "Other", purchaseDate: .now, locations: "None", notes: "", enteredDate: .now, isPlayed: false)
            newCollection = newItem
        }
    }
    
    private func deleteGame(_ game: CD_GameCollection) {
        modelContext.delete(game)
    }
    
    private func togglePlayedStatus(for game: CD_GameCollection) {
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
        let container = try ModelContainer(for: CD_GameCollection.self, configurations: config)

        // Directly reference the static sample data from GameCollection
        @MainActor func insertSampleData() {
            for game in CD_GameCollection.sampleGameCollectionData { // <-- Reference like this!
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
