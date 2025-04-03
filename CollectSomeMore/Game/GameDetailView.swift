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
    
    let genre = ["Action", "Adventure", "Role-Playing", "Strategy", "Sports", "Puzzle", "Racing", "Simulation", "Shooter", "Other", "None"].sorted()
    let brand = [
        "Nintendo", "PlayStation", "Xbox", "Sega", "Other", "None", "PC", "Quest", "Apple", "Android"].sorted()
    let system = [ "NES", "SNES", "N64", "GameCube", "Wii", "Wii U", "Switch", "Vita", "PSP", "Xbox OG", "360", "One", "Series S/X", "PS1", "PS2", "PS3", "PS4", "PS5", "Other", "None", "PC", "MetaStore", "AppStore", "PlayStore", "Genesis", "GameGear", "Saturn", "Sega CD"].sorted()
    let locations = ["Local", "Online", "Steam", "Other", "None"].sorted()
    let collectionState = ["Owned", "Digital", "Borrowed", "Loaned", "Unknown"]
    let rating = ["E", "E10+", "T", "M", "AO", "Unrated", "N/A"]
    
    init(gameCollection: GameCollection, isNew: Bool = false) {
        self.gameCollection = gameCollection
        self.isNew = isNew
    }
    
    var body: some View {
        List {
            Section(header: Text("Game Title")) {
                TextField("", text: Binding(
                    get: { gameCollection.gameTitle ?? "" },
                    set: { gameCollection.gameTitle = $0 }
                ), prompt: Text("Add a title"))
                .font(.custom("Oswald-Regular", size: 16))
                .autocapitalization(.words)
                .disableAutocorrection(false)
                .textContentType(.name)
                .focused($focusedField, equals: .gameTitleField)
            }
            Section(header: Text("Game Details")) {
                Picker("Genre", selection: $gameCollection.genre) {
                    ForEach(genre, id: \.self) { genre in
                        Text(genre).tag(genre)
                    }
                }
                .font(.custom("Oswald-Regular", size: 16))
                .pickerStyle(.menu)
                Picker("Rating", selection: $gameCollection.rating) {
                    ForEach(rating, id: \.self) { rating in
                        Text(rating).tag(rating)
                    }
                }
                .font(.custom("Oswald-Regular", size: 16))
                .pickerStyle(.menu)
                Picker("System", selection: $gameCollection.system) {
                    ForEach(system, id: \.self) { system in
                        Text(system).tag(system)
                    }
                }
                .font(.custom("Oswald-Regular", size: 16))
                .pickerStyle(.menu)
            }
            Section(header: Text("Collection Details")) {
                Picker("Location", selection: $gameCollection.locations) {
                    ForEach(locations, id: \.self) { locations in
                        Text(locations).tag(locations)
                    }
                }
                .font(.custom("Oswald-Regular", size: 16))
                .pickerStyle(.menu)
                Picker("State", selection: $gameCollection.collectionState) {
                    ForEach(collectionState, id: \.self) { collectionState in
                        Text(collectionState).tag(collectionState)
                    }
                }
                .font(.custom("Oswald-Regular", size: 16))
                .pickerStyle(.menu)
                Picker("Brand", selection: $gameCollection.brand) {
                    ForEach(brand, id: \.self) { brand in
                        Text(brand).tag(brand)
                    }
                }
                .font(.custom("Oswald-Regular", size: 16))
                .pickerStyle(.menu)
                DatePicker("Date entered", selection: Binding(
                    get: { gameCollection.enteredDate ?? Date() },
                    set: { gameCollection.enteredDate = $0 }
                ), displayedComponents: .date)
                .disabled(true)
                .font(.custom("Oswald-Regular", size: 16))
            }
            Section(header: Text("Collection Notes")) {
                TextEditor(text: $gameCollection.notes)
                    .lineLimit(nil)
                    .font(.custom("Oswald-Regular", size: 16))
                    .autocorrectionDisabled(true)
                    .autocapitalization(.sentences)
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .border(isTextEditorFocused ? Color.blue : Color.transparent, width: 0)
                    .multilineTextAlignment(.leading)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isTextEditorFocused) // Track focus state
                    .padding(0)
            }
        }
        .onAppear {
            focusedField = .gameTitleField
        }
        .backgroundStyle(Color.gray04) // Default background color for all pages
        .scrollContentBackground(.hidden)
        .navigationBarTitle(isNew ? "Add Game" : "\(gameCollection.gameTitle ?? "")")       .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Save") {
                    modelContext.insert(gameCollection) // Insert the new movie
                    dismiss()
                }
                .disabled(gameCollection.gameTitle?.isEmpty ?? true)
            }
            ToolbarItem(placement: .automatic) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
        }
    }
}

#Preview("Content View") {
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
