//
//  MovieDetail.swift
//  CollectSomeMore
//  Created by Adam Jolicoeur on 6/7/24.
//
//  For Adding a New Movie to the list
//

import SwiftUI
import SwiftData

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
                TextField("", text: $movieCollection.movieTitle, prompt: Text("Add a title"))
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
                DatePicker("Release Date", selection: $movieCollection.releaseDate, displayedComponents: .date)
            }
            Section(header: Text("Collection")) {
                Toggle("Show collection details", isOn: $showingCollectionDetails.animation())
                if showingCollectionDetails {
                    DatePicker("Purchase Date", selection: $movieCollection.purchaseDate, displayedComponents: .date)
                    Picker("Location", selection: $movieCollection.locations) {
                        ForEach(locations, id: \.self) { location in
                            Text(location).tag(location)
                        }
                    }
                    .pickerStyle(.menu)
                    DatePicker("Date entered", selection: $movieCollection.enteredDate, displayedComponents: .date)
                        .disabled(true)
//                    Add IMDB link in the future?
//                    TextField("IMDB", text: $collection.url, prompt: Text("Add an IMDB link"))
//                        .autocapitalization(.none)
//                        .disableAutocorrection(true)
//                        .textContentType(.url)
                }
            }
        }
        .onAppear {
            focusedField = .movieTitleField
        }
        .backgroundStyle(Color.gray04) // Default background color for all pages
        .scrollContentBackground(.hidden)
        .navigationBarTitle(isNew ? "Add Movie" : "\(movieCollection.movieTitle)")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if isNew {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .disabled(movieCollection.movieTitle.isEmpty)
                }
                ToolbarItemGroup {
                    Button("Cancel", role: .cancel) {
                        modelContext.delete(movieCollection)
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
                        Button("Are you sure you want to delete this movie?", role: .destructive) {
                            modelContext.delete(movieCollection)
                            dismiss()
                        }
                    }
                }
                ToolbarItemGroup() {
                    Button("Update") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .disabled(movieCollection.movieTitle.isEmpty)
                }
                
            }
        }
    }
}

#Preview("Movie Detail") {
    NavigationStack {
        MovieDetail(movieCollection: MovieData.shared.collection)
    }
    .modelContainer(MovieData.shared.modelContainer)
}

#Preview("New Movie") {
    NavigationStack {
        MovieDetail(movieCollection: MovieData.shared.collection, isNew: true)
            .navigationBarTitle("New Movie")
            .navigationBarTitleDisplayMode(.large)
    }
    .frame(maxHeight: .infinity)
}
