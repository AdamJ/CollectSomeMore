import SwiftUI
import SwiftData

struct AddGameView: View {
    @State private var showingDetail = false
    @State private var newGame = GameCollection()

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
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @FocusState private var isTextEditorFocused: Bool

    let isNew: Bool
    let isEnabled: Bool = true
    let genre = GameGenres.genre.sorted()
    let brandOptions = GameBrands.brands.sorted()
    @State private var filteredSystems: [String] = []
    let location = GameLocation.location.sorted()
    let rating = GameRating.rating
    let collectionState = GameState.status

    init(gameCollection: GameCollection, isNew: Bool = false) {
        self.gameCollection = gameCollection
        self.isNew = isNew
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                contentView
                if !isNew {
                    collectionView
                }
            }
            .scrollContentBackground(.hidden)
            .background(Colors.surfaceLevel)
            .navigationBarBackButtonHidden(true)
            .navigationTitle(isNew ? "Add a Game" : gameCollection.gameTitle ?? "")
            .navigationBarTitleDisplayMode(.large)
//            .toolbarBackground(Colors.secondaryContainer, for: .navigationBar)
//            .toolbarBackground(.visible, for: .navigationBar)
//            .toolbarColorScheme(.dark)
            .toolbar {
                if isNew {
                    ToolbarItem { EmptyView() }
                } else {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.backward")
//                                    .foregroundColor(Colors.onSurface)
                                Text("Back")
//                                    .foregroundColor(Colors.onSurface)
                            }
                        }
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(isNew ? "Add" : "Save") {
                        modelContext.insert(gameCollection)
                        dismiss()
                    }
                    .bodyBoldStyle()
                    .cornerRadius(100)
                    .disabled(gameCollection.gameTitle?.isEmpty ?? true)
                }
                ToolbarItem(placement: .automatic) {
                    Button("Cancel", role: .destructive) {
                        dismiss()
                    }
//                    .bodyBoldStyle()
//                    .foregroundStyle(.oppositeText)
                    .cornerRadius(100)
                }
            }
        }
        .background(Colors.primaryMaterial)
        .onAppear {
            // Set initial filtered systems when the view appears
            self.filteredSystems = GameSystems.systems(for: gameCollection.brand)

            // If a brand is selected but no system, or if the current system
            // is not valid for the brand, reset the system.
            if let brand = gameCollection.brand,
               !GameSystems.systems(for: brand).contains(gameCollection.system ?? "") {
                gameCollection.system = GameSystems.systems(for: brand).first // Select first valid system or nil
            }
        }
        // Use onChange to react when the 'brand' selection changes
        .onChange(of: gameCollection.brand) { oldBrand, newBrand in // Use oldBrand, newBrand
            self.filteredSystems = GameSystems.systems(for: newBrand)

            if let currentSystem = gameCollection.system,
               !filteredSystems.contains(currentSystem) {
                gameCollection.system = filteredSystems.first // Default to the first available system for the new brand
            }
        }
    }

    @ViewBuilder
    private var headerView: some View {
        
        if !isNew {
            ZStack {
                VStack {
                    VStack(alignment: .leading) {
                        GameChip(gameCollection: gameCollection, description: "")
                        Label {
                            Text(gameCollection.enteredDate?.formatted(date: .long, time: .omitted) ?? "")
                        } icon: {
                            Image(systemName: "calendar")
                        }
                    }
                    .padding(0)
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .center)
                    .cornerRadius(28)
                }
                .padding(.horizontal, 0)
                .padding(.top, 0)
                .padding(.bottom, 0)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .cornerRadius(0)
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
    }

    @ViewBuilder
    private var contentView: some View {
        
        Section {
            TextField("Enter a title", text: Binding(
                get: { gameCollection.gameTitle ?? "" },
                set: { gameCollection.gameTitle = $0 }
            ), axis: .vertical)
            .lineLimit(2)
            .frame(height: 48, alignment: .topLeading)
            .bodyStyle()
            .focused($isTextEditorFocused)
            .autocorrectionDisabled(false)
            .autocapitalization(.sentences)
        } header: {
            VStack(alignment: .center, spacing: Sizing.SpacerSmall) {
                Text("Game Title")
                    .padding(.vertical, Sizing.SpacerXSmall)
                    .padding(.horizontal, Sizing.SpacerMedium)
                    .background(Colors.primaryMaterial)
                    .foregroundColor(Colors.inverseOnSurface)
                    .bodyBoldStyle()
            }
            .cornerRadius(Sizing.SpacerMedium)
        }
        
        Section {
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
                ForEach(brandOptions, id: \.self) { brand in
                    Text(brand).tag(brand)
                }
            }
            .bodyStyle()
            .pickerStyle(.menu)
            
            Picker("System", selection: $gameCollection.system) {
                ForEach(filteredSystems, id: \.self) { system in
                    Text(system).tag(system as String?)
                }
            }
            .bodyStyle()
            .pickerStyle(.menu)
            // Disabled if no brand has been selected
            .disabled(filteredSystems.isEmpty)
        } header: {
            VStack(alignment: .center, spacing: Sizing.SpacerSmall) {
                Text("Game Details")
                    .padding(.vertical, Sizing.SpacerXSmall)
                    .padding(.horizontal, Sizing.SpacerMedium)
                    .background(Colors.primaryMaterial)
                    .foregroundColor(Colors.inverseOnSurface)
                    .bodyBoldStyle()
            }
            .cornerRadius(Sizing.SpacerMedium)
        }
    }
    
    @ViewBuilder
    private var collectionView: some View {
        
        Section {
            Picker("Location", selection: $gameCollection.location) {
                ForEach(location, id: \.self) { location in
                    Text(location).tag(location)
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

            Toggle(isOn: $gameCollection.isPlayed) {
                Text(gameCollection.isPlayed ? "Played" : "Not Played")
            }
            .bodyStyle()
            
            VStack {
                TextEditor(text: $gameCollection.notes)
                    .lineLimit(nil)
                    .bodyStyle()
                    .autocorrectionDisabled(false)
                    .autocapitalization(.sentences)
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .border(isTextEditorFocused ? Colors.blue : Color.clear, width: 0)
                    .multilineTextAlignment(.leading)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isTextEditorFocused) // Track focus state
                    .padding(0)
                Text("Enter any notes here")
                    .minimalStyle()
                    .foregroundStyle(.secondary)
            }
        } header: {
            VStack(alignment: .center, spacing: Sizing.SpacerSmall) {
                Text("Collection Details")
                    .padding(.vertical, Sizing.SpacerXSmall)
                    .padding(.horizontal, Sizing.SpacerMedium)
                    .background(Colors.primaryMaterial)
                    .foregroundColor(Colors.inverseOnSurface)
                    .bodyBoldStyle()
            }
            .cornerRadius(Sizing.SpacerMedium)
        }
    }
}

#Preview("Game Detail View") {
    let sampleGame = GameCollection(
        id: UUID(),
        collectionState: "Owned",
        gameTitle: "Halo: Infinite",
        brand: "Xbox",
        system: "Xbox Series S/X",
        rating: "M",
        genre: "Action",
        purchaseDate: Date(),
        location: "Physical",
        notes: "Need to try this out with friends.",
        enteredDate: Date()
    )
    return GameDetailView(gameCollection: sampleGame)
        .modelContainer(for: [GameCollection.self])
}
