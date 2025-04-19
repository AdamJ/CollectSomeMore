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
    @State private var defaultBrand = "None"
    @State private var defaultSystem = "None"
    @State private var defaultLocation = "Local"
    @State private var defaultCollectionState = "Owned"
    @State private var defaultRating = "M"
    
    @FocusState private var isTextEditorFocused: Bool
    
    enum FocusField {
        case gameTitleField
    }
    
    @FocusState private var focusedField: FocusField?
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let isNew: Bool
    
    let genre = GameGenres.genre.sorted()
    let brand = GameBrands.brands.sorted()
    let system = GameSystems.systems.sorted()
    let locations = GameLocations.location.sorted()
    let rating = GameRatings.ratings.sorted()
    
    let collectionState = ["Owned", "Digital", "Borrowed", "Loaned", "Unknown"]
    
    init(gameCollection: GameCollection, isNew: Bool = false) {
        self.gameCollection = gameCollection
        self.isNew = isNew
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                // Header
                Spacer()
                VStack(alignment: .leading, spacing: 8) {
                    // Title
                    VStack(alignment: .leading, spacing: 0) {
                        Text(gameCollection.gameTitle ?? "")
                            .largeTitleStyle()
                            .lineLimit(2, reservesSpace: false)
                            .foregroundStyle(.text)
                    }
                    .padding(0)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    // Chips Row
                    HStack(alignment: .top, spacing: 8) {
                        // Chip
                        HStack(alignment: .center, spacing: 0) {
                            HStack(alignment: .center, spacing: 8) {
                                Text(gameCollection.system ?? "")
                                    .padding(.top, Sizing.SpacerXSmall)
                                    .padding(.trailing, Sizing.SpacerMedium)
                                    .padding(.bottom, Sizing.SpacerXSmall)
                                    .padding(.leading, Sizing.SpacerMedium)
                                    .background(Colors.surfaceContainerLow)
                                    .foregroundColor(Colors.onSecondaryContainer)
                                    .bodyBoldStyle()
                                    .clipShape(Capsule())
                            }
                            .padding(.leading, 8)
                            .padding(.trailing, 16)
                            .padding(.vertical, 6)
                            .frame(height: 32, alignment: .center)
                            .padding(0)
                            
                        }
                        .padding(0)

                        .background(Colors.secondaryContainer)
                    }
                    .padding(0)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .bottomLeading)
                .background(Colors.secondaryContainer)
            }
            .padding(0)
            .frame(maxWidth: .infinity, minHeight: 150, maxHeight: 200, alignment: .leading)
            .cornerRadius(28)
            .background(Colors.secondaryContainer)
        }
        .padding(.horizontal, 0)
        .padding(.top, 0)
        .padding(.bottom, 0)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        List {
            
            Section(header: Text("Game Details")) {
                TextField("", text: Binding(
                    get: { gameCollection.gameTitle ?? "" },
                    set: { gameCollection.gameTitle = $0 }
                ), prompt: Text("Add a title"))
                .bodyStyle()
                .autocapitalization(.sentences)
                .disableAutocorrection(false)
                .textContentType(.name)
                .focused($focusedField, equals: .gameTitleField)
                
                Picker("Genre", selection: $gameCollection.genre) {
                    ForEach(genre, id: \.self) { genre in
                        Text(genre).tag(genre)
                    }
                }
                .bodyStyle()
                .pickerStyle(.menu)
                
                Picker("Rating", selection: $gameCollection.rating) {
                    ForEach(rating, id: \.self) { rating in
                        Text(rating).tag(rating)
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
                
                Picker("Brand", selection: $gameCollection.brand) {
                    ForEach(brand, id: \.self) { brand in
                        Text(brand).tag(brand)
                    }
                }
                .bodyStyle()
                .pickerStyle(.menu)
                
                DatePicker("Date entered", selection: Binding(
                    get: { gameCollection.enteredDate ?? Date() },
                    set: { gameCollection.enteredDate = $0 }
                ), displayedComponents: .date)
                .bodyStyle()
                .disabled(true)
                
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
        .navigationTitle("Game Details")
        .navigationBarTitleDisplayMode(.inline)
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
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                .bodyStyle()
            }
        }
    }
}

#Preview("Game Detail View") {
    let sampleGame = GameCollection(
            id: UUID(),
            collectionState: "Owned",
            gameTitle: "Halo: Infinite",
            brand: "Xbox",
            system: "Series S/X",
            rating: "M",
            genre: "Action",
            purchaseDate: Date(),
            locations: "Local",
            notes: "It is nice to have notes for the collection, just in case there are fields that do not cover certain bits of information.",
            enteredDate: Date()
        )
        return GameDetailView(gameCollection: sampleGame)
            .modelContainer(for: [GameCollection.self])
}
