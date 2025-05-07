import SwiftUI
import SwiftData

struct AddMovieView: View {
    @State private var showingDetail = false
    @State private var newMovie = MovieCollection() // Create a new instance

    var body: some View {
        Button("Add New Movie") {
            showingDetail = true
        }
        .sheet(isPresented: $showingDetail) {
            MovieDetail(movieCollection: newMovie, isNew: true)
        }
    }
}

struct MovieDetail: View {
    @Bindable var movieCollection: MovieCollection
    @State private var showingOptions = false
    @State private var selection = "None"
    @State private var showingCollectionDetails = false
    @State private var enableLogging = false
    @State private var movieTitle: String = "Details"
    @State private var locationOption: String = "Storage"
    @State private var manualStudio: String = ""
    @State private var studio = "None"
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @FocusState private var isTextEditorFocused: Bool
    
    enum FocusField {
        case movieTitleField
    }
    
    @FocusState private var focusedField: FocusField?
    
    let isNew: Bool
    
    let locations = Locations.locations.sorted()
    let platform = Platform.platforms.sorted()
    let service = Service.service.sorted()
    let studios = Studios.studios.sorted()
    let genres = Genres.genres.sorted()
    let ratings = ["NR", "G", "PG", "PG-13", "R", "Unrated"]
    
    init(movieCollection: MovieCollection, isNew: Bool = false) {
        self.movieCollection = movieCollection
        self.isNew = isNew
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Sizing.SpacerNone) { // Header
            VStack {
                VStack(alignment: .leading) { // Content
                    VStack(alignment: .leading, spacing: Sizing.SpacerSmall) {
                        VStack(alignment: .leading, spacing: Sizing.SpacerNone) { // Header
                            VStack(alignment: .leading, spacing: Sizing.SpacerNone) { // Title
                                Text(movieCollection.movieTitle ?? "")
                                    .largeTitleStyle()
                                    .lineLimit(2, reservesSpace: true)
                                    .foregroundStyle(Colors.onSurface)
                            }
                            .padding(0)
                            .frame(maxWidth: .infinity, alignment: .bottomLeading)
                            
                            HStack(alignment: .top, spacing: Sizing.SpacerSmall) { // Assistive Chips
                                HStack(alignment: .center, spacing: Sizing.SpacerNone) { // Chip
                                    HStack(alignment: .center, spacing: Sizing.SpacerSmall) { // State Layer
                                        Text(movieCollection.ratings ?? "")
                                            .padding(.top, Sizing.SpacerXSmall)
                                            .padding(.trailing, Sizing.SpacerMedium)
                                            .padding(.bottom, Sizing.SpacerXSmall)
                                            .padding(.leading, Sizing.SpacerMedium)
                                            .background(Colors.surfaceContainerLow)
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
                            .padding(0)
                        }
                        .padding(Sizing.SpacerMedium)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Colors.secondaryContainer)
                    }
                    .padding(0)
                }
                .padding(0)
                .frame(maxWidth: .infinity, minHeight: 180, maxHeight: 180, alignment: .bottomLeading)
                .cornerRadius(28)
            }
            .padding(.horizontal, 0)
            .padding(.top, 0)
            .padding(.bottom, 8)
            .background(Colors.secondaryContainer)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .cornerRadius(0)
            
            List {
                Section(header: Text("Movie Details")) {
                    TextField("", text: Binding(
                        get: { movieCollection.movieTitle ?? "" },
                        set: { movieCollection.movieTitle = $0 }
                    ), prompt: Text("Add a title"))
                    .bodyStyle()
                    .autocapitalization(.sentences)
                    .disableAutocorrection(false)
                    .textContentType(.name)
                    .focused($focusedField, equals: .movieTitleField)
                    
                    Picker("Rating", selection: $movieCollection.ratings) {
                        ForEach(ratings, id: \.self) { ratings in
                            Text(ratings).tag(ratings)
                        }
                    }
                    .bodyStyle()
                    .pickerStyle(.menu)
                    
                    Picker("Genre", selection: $movieCollection.genre) {
                        ForEach(genres, id: \.self) { genre in
                            Text(genre).tag(genre)
                        }
                    }
                    .bodyStyle()
                    .pickerStyle(.menu)
                    
                    Picker("Studio", selection: $movieCollection.studio) {
                        ForEach(studios, id: \.self) { studio in
                            Text(studio).tag(studio)
                        }
                    }
                    .bodyStyle()
                    .pickerStyle(.menu)
                    
                    Picker("Platform", selection: $movieCollection.platform) {
                        ForEach(platform, id: \.self) { platform in
                            Text(platform).tag(platform)
                        }
                    }
                    .bodyStyle()
                    .pickerStyle(.menu)
                    
                    DatePicker("Release Date", selection: Binding(
                        get: { movieCollection.releaseDate ?? Date() },
                        set: { movieCollection.releaseDate = $0 }
                    ), displayedComponents: .date)
                    .bodyStyle()
                }
                .captionStyle()
                
                Section(header: Text("Collection Details")) {
                    Picker("Location", selection: $movieCollection.locations) {
                        ForEach(locations, id: \.self) { location in
                            Text(location).tag(location)
                        }
                    }
                    .bodyStyle()
                    .pickerStyle(.menu)
                    
                    DatePicker("Purchase Date", selection: Binding(
                        get: { movieCollection.purchaseDate ?? Date() },
                        set: { movieCollection.purchaseDate = $0 }
                    ), displayedComponents: .date)
                    .bodyStyle()
                    
                    DatePicker("Date Added", selection: Binding(
                        get: { movieCollection.enteredDate ?? Date() },
                        set: { movieCollection.enteredDate = $0 }
                    ), displayedComponents: .date)
                    .bodyStyle()
                    .disabled(true)
                    
                    Section(header: Text("Notes")) {
                        TextEditor(text: $movieCollection.notes)
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
                focusedField = .movieTitleField
            }
            .scrollContentBackground(.hidden)
            .background(Colors.surfaceLevel)
            .navigationTitle(movieCollection.movieTitle?.isEmpty ?? true ? "New" : "Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Save") {
                        modelContext.insert(movieCollection) // Insert the new movie
                        dismiss()
                    }
                    .bodyStyle()
                    .disabled(movieCollection.movieTitle?.isEmpty ?? true)
                }
                ToolbarItem(placement: .automatic) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                    .bodyStyle()
                }
            }
        }
        .background(Colors.secondaryContainer)
    }
}

#Preview("Movie Detail View") {
    let sampleMovie = MovieCollection(
        id: UUID(),
        movieTitle: "Warriors of the Wind",
        ratings: "G",
        genre: "Animated",
        studio: "Studio Ghibli",
        platform: "None",
        releaseDate: .now,
        purchaseDate: .now,
        locations: "Storage",
        enteredDate: .now,
        notes: "One of my favorite movies.",
        )
        return MovieDetail(movieCollection: sampleMovie)
            .modelContainer(for: [MovieCollection.self])
}
