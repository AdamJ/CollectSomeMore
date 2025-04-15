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
    @Environment(\.editMode) private var editMode
    @Query(sort: \GameCollection.gameTitle) private var collections: [GameCollection]

    enum SortOption {
        case gameTitle, brand, locations
    }

    @State private var newCollection: GameCollection?
    @State private var sortOption: SortOption = .gameTitle
    @State private var showingExportSheet = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var searchGamesText: String = ""

    @State private var filterSystem: String = "All"
    @State private var filterLocation: String = "All"
    @State private var filterBrand: String = "All"

    let allPossibleBrands: [String] = ["All", "Nintendo", "PlayStation", "Xbox", "Sega", "Other", "None", "PC", "Quest", "Apple", "Android"].sorted()
    let allPossibleSystems: [String] = ["All", "NES", "SNES", "N64", "GameCube", "Wii", "Wii U", "Switch", "Vita", "PSP", "Xbox OG", "Xbox 360", "One", "Series S/X", "PS1", "PS2", "PS3", "PS4", "PS5", "Other", "None", "PC", "MetaStore", "AppStore", "PlayStore", "Genesis", "GameGear", "Saturn", "Sega CD"].sorted()
    let allPossibleLocations: [String] = ["All", "Cabinet", "Steam", "GamePass", "PlayStation Plus", "Nintendo Switch Online", "Epic Game Store", "Other", "None"].sorted()

    private var availableSystems: Set<String> {
        Set(collections.compactMap { $0.system })
    }
    private var availableLocations: Set<String> {
        Set(collections.compactMap { $0.locations })
    }
    private var availableBrands: Set<String> {
        Set(collections.compactMap { $0.brand })
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
        var notes: String
        var enteredDate: Date

        init(collectionState: String, gameTitle: String, brand: String, system: String, genre: String, rating: String, purchaseDate: Date, locations: String, notes: String?, enteredDate: Date) {
            self.collectionState = collectionState
            self.gameTitle = gameTitle
            self.brand = brand
            self.system = system
            self.genre = genre
            self.rating = rating
            self.purchaseDate = purchaseDate
            self.locations = locations
            self.notes = notes ?? ""
            self.enteredDate = enteredDate
        }

        func toCSV() -> String {
            return "\(collectionState),\(gameTitle),\(brand),\(system),\(genre),\(rating)\(purchaseDate),\(locations),\(notes),\(enteredDate)"
        }
    }

    var filteredAndSearchedCollections: [GameCollection] {
        collections
            .filter { item in
                (filterBrand == "All" || item.brand == filterBrand) &&
                (filterSystem == "All" || item.system == filterSystem) &&
                (filterLocation == "All" || item.locations == filterLocation) &&
                (searchGamesText.isEmpty || (item.gameTitle?.localizedStandardContains(searchGamesText) ?? true))
            }
            .sorted(by: { item1, item2 in
                switch sortOption {
                case .gameTitle:
                    return item1.gameTitle ?? "" < item2.gameTitle ?? ""
                case .brand:
                    return item1.brand ?? "" < item2.brand ?? ""
                case .locations:
                    return item1.locations ?? "" < item2.locations ?? ""
                }
            })
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundTertiary
                    .opacity(0.1)
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: Constants.SpacerNone) {
                    Rectangle()
                        .frame(height: 0)
                        .background(Color.backgroundTertiary.opacity(0.2))
                    HStack {
                        Menu("System:", systemImage: "line.3.horizontal.decrease.circle") {
                            Picker("System", selection: $filterSystem) {
                                ForEach(allPossibleSystems, id: \.self) { system in
                                    Text(system)
                                        .tag(system)
                                        .disabled(!availableSystems.contains(system) && system != "All Systems")
                                }
                            }
                            .pickerStyle(.automatic)
                        }
                        .bodyStyle()
                        .padding(.bottom, Constants.SpacerNone)
                        .disabled(collections.isEmpty)
                        Text("\(filterSystem)")
                            .bodyStyle()
                        Spacer()
                        Menu("Brand:", systemImage: "line.3.horizontal.decrease.circle") {
                            Picker("Brand", selection: $filterBrand) {
                                ForEach(allPossibleBrands, id: \.self) { brand in
                                    Text(brand)
                                        .tag(brand)
                                        .disabled(!availableBrands.contains(brand) && brand != "All")
                                }
                            }
                            .pickerStyle(.automatic)
                        }
                        .bodyStyle()
                        .padding(.bottom, Constants.SpacerNone)
                        .disabled(collections.isEmpty)
                        Text("\(filterBrand)")
                            .bodyStyle()
                    }
                    .padding(.top, Constants.SpacerSmall)
                    .padding(.horizontal)
                    
                    if collections.isEmpty {
                        ContentUnavailableView {
                            Label("There are no games to show", systemImage: "xmark.bin")
                                .padding()
                                .titleStyle()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .navigationTitle("Games (\(collections.count))")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItemGroup(placement: .primaryAction) {
                                Button(action: addCollection) {
                                    Label("Add Game", systemImage: "plus.app")
                                }
                            }
                        }
                    } else if filteredAndSearchedCollections.isEmpty {
                        ContentUnavailableView {
                            Label("No movies match your criteria", systemImage: "xmark.bin")
                            // Label("No movies match your criteria \(filterSystem) \(filterBrand)", systemImage: "xmark.bin")
                                .padding()
                                .title2Style()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .navigationTitle("Games (\(collections.count))")
                        .navigationBarTitleDisplayMode(.inline)
                    } else {
                        List {
                            ForEach(filteredAndSearchedCollections) { collection in
                                NavigationLink(destination: GameDetailView(gameCollection: collection)) {
                                    GameRowView(gameCollection: collection)
                                }
                                .listRowBackground(Color.transparent)
                            }
                            .onDelete(perform: deleteItems)
                        }
                        .padding(.horizontal, Constants.SpacerNone)
                        .padding(.vertical, Constants.SpacerNone)
                        .scrollContentBackground(.hidden)
                        .navigationTitle("Games (\(collections.count))")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbarBackground(.hidden)
                        .toolbar {
                            ToolbarItemGroup(placement: .primaryAction) {
                                Button(action: addCollection) {
                                    Label("Add Game", systemImage: "plus.app")
                                        .labelStyle(.titleAndIcon)
                                }
                            }
                            ToolbarItemGroup(placement: .topBarLeading) {
                                Menu("Sort by", systemImage: "list.bullet.circle") {
                                    Picker("Sort By", selection: $sortOption) {
                                        Text("Title").tag(SortOption.gameTitle)
                                        Text("Brand").tag(SortOption.brand)
                                        Text("Location").tag(SortOption.locations)
                                    }
                                    .pickerStyle(.automatic)
                                }
                                .bodyStyle()
                                .disabled(collections.isEmpty)
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
                                NavigationLink(destination: HowToAdd()) {
                                    Label("How to add games", systemImage: "questionmark.circle")
                                }
                            }
                        }
                    }
                }
                .padding(.leading, Constants.SpacerNone)
                .padding(.trailing, Constants.SpacerNone)
                .padding(.vertical, Constants.SpacerNone)
                .background(Gradient(colors: darkBottom))
                .foregroundStyle(.gray09)
                .shadow(color: Color.gray03.opacity(0.16), radius: 8, x: 0, y: 4)
            }
        }
        .searchable(text: $searchGamesText, prompt: "Search for a game")
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
            filterBrand = "All"
        }
    }

    private func addCollection() {
        withAnimation {
            let newItem = GameCollection(id: UUID(), collectionState: "", gameTitle: "", brand: "None", system: "None", rating: "M", genre: "Other", purchaseDate: .now, locations: "None", notes: "", enteredDate: .now)
            newCollection = newItem
        }
    }

    private func createGameCSVFile() -> URL? {
        let headers = "Collection State,Title,Brand,System,Genre,Rating,Purchase Date,Location,Notes,Date Entered\n"
        let rows = collections.map { Record(collectionState: $0.collectionState ?? "", gameTitle: $0.gameTitle ?? "", brand: $0.brand ?? "", system: $0.system ?? "", genre: $0.genre ?? "", rating: $0.rating ?? "", purchaseDate: $0.purchaseDate ?? Date(), locations: $0.locations ?? "", notes: $0.notes, enteredDate: $0.enteredDate ?? Date()).toCSV() }.joined(separator: "\n")
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

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
}

#Preview("Content View") {
    GameListView()
        .modelContainer(GameData.shared.modelContainer)
}
