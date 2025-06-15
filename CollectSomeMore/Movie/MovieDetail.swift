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

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @FocusState private var isTextEditorFocused: Bool
    
    @State private var showingOptions = false
    @State private var selection = "None"
    @State private var showingCollectionDetails = false
    @State private var enableLogging = false
    @State private var movieTitle: String = "Details"
    @State private var locationOption: String = "Storage"
    @State private var manualStudio: String = ""
    @State private var studio = "None"
    
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
    let ratings = Ratings.ratings
    
    init(movieCollection: MovieCollection, isNew: Bool = false) {
        self.movieCollection = movieCollection
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
            .navigationTitle(isNew ? "Add a Movie" : movieCollection.movieTitle ?? "")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Colors.secondaryContainer, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark)
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
                                    .foregroundColor(.white)
                                Text("Back")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(isNew ? "Add" : "Save") {
                        modelContext.insert(movieCollection)
                        dismiss()
                    }
                    .bodyBoldStyle()
                    .disabled(movieCollection.movieTitle?.isEmpty ?? true)
                }
                ToolbarItem(placement: .automatic) {
                    Button("Cancel", role: .destructive) {
                        dismiss()
                    }
                    .foregroundStyle(Color.white)
                    .bodyBoldStyle()
                }
            }
        }
        .background(Colors.primaryMaterial)
    }
    
    @ViewBuilder
    private var headerView: some View {
        
        if !isNew {
            ZStack {
                VStack {
                    VStack(alignment: .leading) {
                        MovieChip(movieCollection: movieCollection, description: "")
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
        
        Section(header: Text("Movie Title")) {
            TextField("Enter a title", text: Binding(
                get: { movieCollection.movieTitle ?? "" },
                set: { movieCollection.movieTitle = $0 }
            ), axis: .vertical)
            .lineLimit(2)
            .frame(height: 48, alignment: .topLeading)
            .bodyStyle()
            .focused($isTextEditorFocused)
            .autocorrectionDisabled(false)
            .autocapitalization(.sentences)
        }
        .captionStyle()
        
        Section(header: Text("Movie Details")) {
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
    }
    
    @ViewBuilder
    private var collectionView: some View {
        
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
            
            DatePicker("Date Entered", selection: Binding(
                get: { movieCollection.enteredDate ?? Date() },
                set: { movieCollection.enteredDate = $0 }
            ), displayedComponents: .date)
            .bodyStyle()
            .disabled(true)
            
            Toggle(isOn: $movieCollection.isWatched) { // Bind directly to movie.isWatched
                Text(movieCollection.isWatched ? "Watched" : "Not Watched")
            }
            .bodyStyle()
            
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
}

#Preview("Movie Detail View") {
    let sampleMovie = MovieCollection(
        id: UUID(),
        movieTitle: "Warriors of the Wind",
        ratings: "G",
        genre: "Animated",
        studio: "None",
        platform: "None",
        releaseDate: .now,
        purchaseDate: .now,
        locations: "Storage",
        enteredDate: .now,
        notes: "One of my favorite movies.",
        isWatched: true
        )
        return MovieDetail(movieCollection: sampleMovie)
            .modelContainer(for: [MovieCollection.self])
}
