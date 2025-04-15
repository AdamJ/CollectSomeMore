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
    @Query private var movies: [MovieCollection]
    @Query private var games: [GameCollection]
    
    @FocusState private var isTextEditorFocused: Bool
    
    enum FocusField {
        case movieTitleField
    }
    
    @FocusState private var focusedField: FocusField?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let isNew: Bool
    
    let genres = ["Action", "Adventure", "Anime", "Animated", "Biography", "Comedy", "Documentary", "Drama", "Educational", "Family", "Fantasy", "Historical", "Horror", "Indie", "Music", "Mystery", "Romance", "Sci-Fi", "Superhero", "Suspense", "Thriller", "Western", "Other"].sorted()
    let ratings = ["NR", "G", "PG", "PG-13", "R", "Unrated"]
    let locations = ["Cabinet", "iTunes", "Network", "Other", "None"]
    let studios = ["20th Century Fox", "Warner Bros.", "Paramount Pictures", "Sony Pictures", "Disney", "Universal Pictures", "Apple", "Amazon", "Ghibli"].sorted()
    let platforms = ["Home Theater", "Apple TV+", "Prime Video", "Apple TV", "Netflix", "Hulu", "Disney+", "HBO Max", "YouTube", "ESPN+", "Peacock"].sorted()
    
    init(movieCollection: MovieCollection, isNew: Bool = false) {
        self.movieCollection = movieCollection
        self.isNew = isNew
    }
    
    var body: some View {
        List {
            Section(header: Text("Movie Title")) {
                TextField("", text: Binding(
                    get: { movieCollection.movieTitle ?? "" },
                    set: { movieCollection.movieTitle = $0 }
                ), prompt: Text("Add a title"))
                .bodyStyle()
                .autocapitalization(.words)
                .disableAutocorrection(false)
                .textContentType(.name)
                .focused($focusedField, equals: .movieTitleField)
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
                    ForEach(platforms, id: \.self) { platform in
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
            }
            .captionStyle()
            
            Section(header: Text("Collection Notes")) {
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
        .onAppear {
            focusedField = .movieTitleField
        }
        .backgroundStyle(Color.gray04) // Default background color for all pages
        .scrollContentBackground(.hidden)
        .navigationBarTitle(isNew ? "Add Movie" : "\(movieCollection.movieTitle ?? "Movie")")
        .navigationBarTitleDisplayMode(.large)
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
}

#Preview("Movie Detail View") {
    let sampleMovie = MovieCollection(
        id: UUID(),
        movieTitle: "Warriors of the Wind",
        ratings: "G",
        genre: "Animated",
        studio: "Ghibli",
        platform: "None",
        releaseDate: .now,
        purchaseDate: .now,
        locations: "Cabinet",
        enteredDate: .now,
        notes: "It is nice to have notes for the collection, just in case there are fields that do not cover certain bits of information.",
        )
        return MovieDetail(movieCollection: sampleMovie)
            .modelContainer(for: [MovieCollection.self])
}
