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
    
    enum FocusField {
        case gameTitleField
    }
    
    @FocusState private var focusedField: FocusField?
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let isNew: Bool
    
    let genre = ["Action", "Adventure", "Role-Playing", "Strategy", "Sports", "Puzzle", "Racing", "Simulation", "Other", "None"].sorted()
    let console = [
        "NES", "Super NES", "N64", "GameCube", "Wii", "Wii U", "Nintendo Switch", "PS Vita", "PSP", "XBox", "XBox 360", "XBox One", "XBox Series", "PlayStation", "PlayStation 2", "PlayStation 3", "PlayStation 4", "PS5", "Other", "None"].sorted()
    let locations = ["Cabinet", "Steam", "GamePass", "PlayStation Plus", "Nintendo Switch Online", "Epic Game Store", "Other", "None"].sorted()
    
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
                .autocapitalization(.words)
                .disableAutocorrection(false)
                .textContentType(.name)
                .focused($focusedField, equals: .gameTitleField)
            }
            Section(header: Text("Details")) {
                Picker("Console", selection: $gameCollection.console) {
                    ForEach(console, id: \.self) { console in
                        Text(console).tag(console)
                    }
                }
                .pickerStyle(.menu)
                Picker("Genre", selection: $gameCollection.genre) {
                    ForEach(genre, id: \.self) { genre in
                        Text(genre).tag(genre)
                    }
                }
                .pickerStyle(.menu)
                Picker("Location", selection: $gameCollection.locations) {
                    ForEach(locations, id: \.self) { locations in
                        Text(locations).tag(locations)
                    }
                }
                .pickerStyle(.menu)
            }
        }
        .onAppear {
            focusedField = .gameTitleField
        }
        .backgroundStyle(Color.gray04) // Default background color for all pages
        .scrollContentBackground(.hidden)
        .navigationBarTitle(isNew ? "Add Game" : "\(gameCollection.gameTitle ?? "")")
        .navigationBarTitleDisplayMode(.large)
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
