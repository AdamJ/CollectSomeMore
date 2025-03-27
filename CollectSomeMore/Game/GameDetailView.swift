//
//  GameDetail.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/26/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI
import SwiftData

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
    let console = ["NES", "Super NES", "N64", "GameCube", "Wii", "Wii U", "Nintendo Switch", "PlayStation Vita", "PSP", "XBox", "XBox360", "XBoxOne", "XBoxSeriesX", "XBoxSeriesS", "PlayStation", "PlayStation2", "PlayStation3", "PlayStation4", "PlayStation5", "Other", "None"].sorted()
    let locations = ["Cabinet", "Steam", "GamePass", "PlayStation Plus", "Nintendo Switch Online", "Epic Game Store", "Other", "None"].sorted()
    
    init(gameCollection: GameCollection, isNew: Bool = false) {
        self.gameCollection = gameCollection
        self.isNew = isNew
    }
    
    var body: some View {
        Text("Game Detail View")
        List {
            Section(header: Text("Game Title")) {
                TextField("", text: $gameCollection.gameTitle, prompt: Text("Add a title"))
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
            }
        }
        .onAppear {
            focusedField = .gameTitleField
        }
        .backgroundStyle(Color.gray04) // Default background color for all pages
        .scrollContentBackground(.hidden)
        .navigationBarTitle(isNew ? "Add Movie" : "\(gameCollection.gameTitle)")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if isNew {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .disabled(gameCollection.gameTitle.isEmpty)
                }
                ToolbarItemGroup {
                    Button("Cancel", role: .cancel) {
                        modelContext.delete(gameCollection)
                        dismiss()
                    }
                    .labelStyle(.titleOnly)
                    .buttonStyle(.borderless)
                }
            } else {
                ToolbarItemGroup() {
                    Button("Delete") {
                        showingOptions = true
                    }
                    .foregroundStyle(.error)
                    .confirmationDialog("Confirm to delete", isPresented: $showingOptions, titleVisibility: .visible) {
                        Button("Confirm", role: .destructive) {
                            modelContext.delete(gameCollection)
                            dismiss()
                        }
                    }
                }
                ToolbarItemGroup() {
                    Button("Done") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .disabled(gameCollection.gameTitle.isEmpty)
                }
                
            }
        }
    }
}
