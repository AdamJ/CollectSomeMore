//
//  GameDetail.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/26/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI
import SwiftData

struct AddGameView: View {
    @State private var showingDetail = false
    @State private var newGame = GameCollection() // Create a new instance

    var body: some View {
        Button("Add New Game") {
            showingDetail = true
        }
        .sheet(isPresented: $showingDetail) {
            GameDetailView(gameCollection: newGame, isNew: true)
        }
    }
}

struct GameDetailView: View {
    @Bindable var gameCollection: GameCollection
    
    @State private var showingOptions = false
    @State private var selection = "None"
    @State private var showingCollectionDetails = false
    @State private var enableLogging = false
    @State private var defaultGenre = "None"
    @State private var defaultBrand = "Any"
    @State private var defaultSystem = "None"
    @State private var defaultLocation = "None"
    @State private var defaultCollectionState = "Owned"
    @State private var defaultRating = "Unknown"
    
    @FocusState private var isTextEditorFocused: Bool
    
    enum FocusField {
        case gameTitleField
    }
    
    @FocusState private var focusedField: FocusField?
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \GameCollection.gameTitle) private var games: [GameCollection] // Fetch games
    
    let isNew: Bool
    
    let genre = GameGenres.genre.sorted()
    let brand = GameBrands.brands.sorted()
    let system = GameSystems.systems.sorted()
    let locations = GameLocations.location.sorted()
    let rating = GameRatings.ratings
    
    let collectionState = ["Owned", "Digital", "Borrowed", "Loaned", "Wishlist", "Unknown"]
    
    init(gameCollection: GameCollection, isNew: Bool = false) {
        self.gameCollection = gameCollection
        self.isNew = isNew
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Sizing.SpacerNone) { // Header
            if !isNew {
                VStack {
                    VStack(alignment: .leading) { // Content
                        GameChip(gameCollection: gameCollection, description: "")
                    }
                    .padding(0)
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .bottomLeading)
                    .cornerRadius(28)
                }
                .padding(.horizontal, 0)
                .padding(.top, 0)
                .padding(.bottom, 0)
                .background(Colors.secondaryContainer)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .cornerRadius(0)
                
                List {
                    Section() {
                        TextField("", text: Binding(
                            get: { gameCollection.gameTitle ?? "" },
                            set: { gameCollection.gameTitle = $0 }
                        ), prompt: Text("Title"))
                        .bodyStyle()
                        .autocapitalization(.sentences)
                        .disableAutocorrection(false)
                        .textContentType(.name)
                        .focused($focusedField, equals: .gameTitleField)
                        
                        Picker("Rating", selection: $gameCollection.rating) {
                            ForEach(rating, id: \.self) { rating in
                                Text(rating).tag(rating)
                            }
                        }
                        .bodyStyle()
                        .pickerStyle(.menu)

                        Picker("Genre", selection: $gameCollection.genre) {
                            ForEach(genre, id: \.self) { genre in
                                Text(genre).tag(genre)
                            }
                        }
                        .bodyStyle()
                        .pickerStyle(.menu)
                        
                        Picker("Brand", selection: $gameCollection.brand) {
                            ForEach(brand, id: \.self) { brand in
                                Text(brand).tag(brand)
                            }
                        }
                        .bodyStyle()
                        .pickerStyle(.menu)
                        
                        Picker("System", selection: $gameCollection.system) {
                            ForEach(system, id: \.self) { system in
                                Text(system).tag(system)
                            }
                        }
                        .bodyStyle()
                        .pickerStyle(.menu)
                    }
                    .captionStyle()
                    
                    Section(header: Text("Collection Details")) {
                        Picker("Location", selection: $gameCollection.locations) {
                            ForEach(locations, id: \.self) { locations in
                                Text(locations).tag(locations)
                            }
                        }
                        .bodyStyle()
                        .pickerStyle(.menu)
                        
                        Picker("State", selection: $gameCollection.collectionState) {
                            ForEach(collectionState, id: \.self) { collectionState in
                                Text(collectionState).tag(collectionState)
                            }
                        }
                        .bodyStyle()
                        .pickerStyle(.menu)
                        
                        DatePicker("Date Entered", selection: Binding(
                            get: { gameCollection.enteredDate ?? Date() },
                            set: { gameCollection.enteredDate = $0 }
                        ), displayedComponents: .date)
                        .bodyStyle()
                        .disabled(true)
                        
                        Toggle(isOn: $gameCollection.isPlayed) { // Bind directly to game.isPlayed
                            Text(gameCollection.isPlayed ? "Played" : "Not Played")
                        }
                        .bodyStyle()
                        
                        Section(header: Text("Notes")) {
                            TextEditor(text: $gameCollection.notes)
                                .lineLimit(nil)
                                .bodyStyle()
                                .autocorrectionDisabled(false)
                                .autocapitalization(.sentences)
                                .frame(maxWidth: .infinity)
                                .frame(height: 120)
                                .border(isTextEditorFocused ? Color.blue : Color.transparent, width: 0)
                                .multilineTextAlignment(.leading)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .focused($isTextEditorFocused) // Track focus state
                                .padding(0)
                        }
                        .captionStyle()
                    }
                    .captionStyle()
                }
                .onAppear {
                    focusedField = .gameTitleField
                }
                .scrollContentBackground(.hidden)
                .background(Colors.surfaceLevel)
                .navigationTitle(gameCollection.gameTitle ?? "")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Save") {
                            modelContext.insert(gameCollection) // Insert the new movie
                            dismiss()
                        }
                        .bodyStyle()
                        .disabled(gameCollection.gameTitle?.isEmpty ?? true)
                    }
                    ToolbarItem(placement: .automatic) {
                        Button("Cancel", role: .destructive) {
                            dismiss()
                        }
                        .bodyStyle()
                    }
                }

            } else {

                List {
                    Section() {
                        TextField("", text: Binding(
                            get: { gameCollection.gameTitle ?? "" },
                            set: { gameCollection.gameTitle = $0 }
                        ), prompt: Text("Title"))
                        .bodyStyle()
                        .autocapitalization(.sentences)
                        .disableAutocorrection(false)
                        .textContentType(.name)
                        .focused($focusedField, equals: .gameTitleField)

                        Picker("Rating", selection: $gameCollection.rating) {
                            ForEach(rating, id: \.self) { rating in
                                Text(rating).tag(rating)
                            }
                        }
                        .bodyStyle()
                        .pickerStyle(.menu)

                        Picker("Genre", selection: $gameCollection.genre) {
                            ForEach(genre, id: \.self) { genre in
                                Text(genre).tag(genre)
                            }
                        }
                        .bodyStyle()
                        .pickerStyle(.menu)
                        
                        Picker("Brand", selection: $gameCollection.brand) {
                            ForEach(brand, id: \.self) { brand in
                                Text(brand).tag(brand)
                            }
                        }
                        .bodyStyle()
                        .pickerStyle(.menu)
                        
                        Picker("System", selection: $gameCollection.system) {
                            ForEach(system, id: \.self) { system in
                                Text(system).tag(system)
                            }
                        }
                        .bodyStyle()
                        .pickerStyle(.menu)
                    }
                    .captionStyle()
                    
                    Section(header: Text("Collection Details")) {
                        Picker("Location", selection: $gameCollection.locations) {
                            ForEach(locations, id: \.self) { locations in
                                Text(locations).tag(locations)
                            }
                        }
                        .bodyStyle()
                        .pickerStyle(.menu)
                        
                        DatePicker("Purchase Date", selection: Binding(
                            get: { gameCollection.purchaseDate ?? Date() },
                            set: { gameCollection.purchaseDate = $0 }
                        ), displayedComponents: .date)
                        .bodyStyle()
                        
                        Picker("State", selection: $gameCollection.collectionState) {
                            ForEach(collectionState, id: \.self) { collectionState in
                                Text(collectionState).tag(collectionState)
                            }
                        }
                        .bodyStyle()
                        .pickerStyle(.menu)
                        
                        DatePicker("Date Entered", selection: Binding(
                            get: { gameCollection.enteredDate ?? Date() },
                            set: { gameCollection.enteredDate = $0 }
                        ), displayedComponents: .date)
                        .bodyStyle()
                        .disabled(true)
                        
                        Toggle(isOn: $gameCollection.isPlayed) { // Bind directly to game.isPlayed
                            Text(gameCollection.isPlayed ? "Played" : "Not Played")
                                .bodyStyle()
                        }
                        
                        Section(header: Text("Notes")) {
                            TextEditor(text: $gameCollection.notes)
                                .lineLimit(nil)
                                .bodyStyle()
                                .autocorrectionDisabled(false)
                                .autocapitalization(.sentences)
                                .frame(maxWidth: .infinity)
                                .frame(height: 120)
                                .border(isTextEditorFocused ? Color.blue : Color.transparent, width: 0)
                                .multilineTextAlignment(.leading)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .focused($isTextEditorFocused) // Track focus state
                                .padding(0)
                        }
                        .captionStyle()
                    }
                    .captionStyle()
                }
                .onAppear {
                    focusedField = .gameTitleField
                }
                .scrollContentBackground(.hidden)
                .background(Colors.surfaceLevel)
                .navigationTitle("Add a Game")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Add") {
                            modelContext.insert(gameCollection) // Insert the new movie
                            dismiss()
                        }
                        .bodyStyle()
                        .disabled(gameCollection.gameTitle?.isEmpty ?? true)
                    }
                    ToolbarItem(placement: .automatic) {
                        Button("Cancel", role: .destructive) {
                            dismiss()
                        }
                        .bodyStyle()
                    }
                }
            }
        }
        .background(Colors.secondaryContainer)
    }
}

//#Preview("Game Detail View") {
//    let sampleGame = GameCollection(
//            id: UUID(),
//            collectionState: "Owned",
//            gameTitle: "Halo: Infinite",
//            brand: "Xbox",
//            system: "Xbox Series S/X",
//            rating: "M",
//            genre: "Action",
//            purchaseDate: Date(),
//            locations: "Cabinet",
//            notes: "Need to try this out with friends.",
//            enteredDate: Date()
//        )
//        return GameDetailView(gameCollection: sampleGame)
//            .modelContainer(for: [GameCollection.self])
//}
#Preview("Game Detail View") {
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
