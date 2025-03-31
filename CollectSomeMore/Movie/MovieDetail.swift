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
    
    enum FocusField {
        case movieTitleField
    }
    
    @FocusState private var focusedField: FocusField?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let isNew: Bool
    
    let genres = ["Action", "Adventure", "Anime", "Animated", "Biography", "Comedy", "Documentary", "Drama", "Educational", "Family", "Fantasy", "Historical", "Horror", "Indie", "Music", "Mystery", "Romance", "Sci-Fi", "Superhero", "Suspense", "Thriller", "Western", "Other"]
    let ratings = ["NR", "G", "PG", "PG-13", "R", "Unrated"]
    let locations = ["Cabinet", "iTunes", "Network", "Other", "None"]
    
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
                    .autocapitalization(.words)
                    .disableAutocorrection(false)
                    .textContentType(.name)
                    .focused($focusedField, equals: .movieTitleField)
            }
            Section(header: Text("Movie Details")) {
                Picker("Rating", selection: $movieCollection.ratings) {
                    ForEach(ratings, id: \.self) { rating in
                        Text(rating).tag(rating)
                    }
                }
                .pickerStyle(.menu)
                Picker("Genre", selection: $movieCollection.genre) {
                    ForEach(genres, id: \.self) { genre in
                        Text(genre).tag(genre)
                    }
                }
                .pickerStyle(.menu)
                DatePicker("Release Date", selection: Binding(
                            get: { movieCollection.releaseDate ?? Date() },
                            set: { movieCollection.releaseDate = $0 }
                        ), displayedComponents: .date)
            }
            Section(header: Text("Collection")) {
                Toggle("Show collection details", isOn: $showingCollectionDetails.animation())
                if showingCollectionDetails {
                    DatePicker("Purchase Date", selection: Binding(
                                get: { movieCollection.purchaseDate ?? Date() },
                                set: { movieCollection.purchaseDate = $0 }
                            ), displayedComponents: .date)
                    Picker("Location", selection: $movieCollection.locations) {
                        ForEach(locations, id: \.self) { location in
                            Text(location).tag(location)
                        }
                    }
                    .pickerStyle(.menu)
                    DatePicker("Date entered", selection: Binding(
                        get: { movieCollection.enteredDate ?? Date() },
                        set: { movieCollection.enteredDate = $0 }
                    ), displayedComponents: .date)
                }
            }
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
                .disabled(movieCollection.movieTitle?.isEmpty ?? true)
            }
            ToolbarItem(placement: .automatic) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
        }
    }
}

//@MainActor
//private func movieToolbar(isNew: Bool, showingOptions: Binding<Bool>, movieCollection: Binding<MovieCollection>) -> some ToolbarContent {
//    return ToolbarItemGroup(placement: .topBarTrailing) {
//        if isNew {
//            Button("Save") {
//                // Handle save action
//            }
//            .buttonStyle(.bordered)
//            .disabled(movieCollection.wrappedValue.movieTitle?.isEmpty ?? true)
//
//            Button("Cancel", role: .cancel) {
//                // Handle cancel action, such as deletion if needed
//            }
//            .labelStyle(.titleOnly)
//            .buttonStyle(.borderless)
//        } else {
//            Button("Delete") {
//                showingOptions.wrappedValue = true
//            }
//            .foregroundStyle(.error)
//            .confirmationDialog("Confirm to delete", isPresented: showingOptions, titleVisibility: .visible) {
//                Button("Are you sure you want to delete this movie?", role: .destructive) {
//                    // Handle movie deletion
//                }
//            }
//
//            Button("Update") {
//                // Handle update action
//            }
//            .buttonStyle(.bordered)
//            .disabled(movieCollection.wrappedValue.movieTitle?.isEmpty ?? true)
//        }
//    }
//}
