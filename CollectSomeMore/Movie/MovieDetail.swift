//
//  MovieDetail.swift
//  CollectSomeMore
//  Created by Adam Jolicoeur on 6/7/24.
//
//  For Adding a New Movie to the list
//

import SwiftUI

struct MovieDetail: View {
    @Bindable var collection: Collection
    @State private var showingOptions = false
    @State private var selection = "None"
    @State private var showingCollectionDetails = false
    @State private var enableLogging = false
    @State private var movieTitle: String = "Details"
    
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
    
    init(collection: Collection, isNew: Bool = false) {
        self.collection = collection
        self.isNew = isNew
    }
    
    var body: some View {
        List {
            Section(header: Text("Movie Title")) {
                TextField("", text: $collection.movieTitle, prompt: Text("Add a title"))
                    .autocapitalization(.words)
                    .disableAutocorrection(false)
                    .textContentType(.name)
                    .focused($focusedField, equals: .movieTitleField)
            }
            Section(header: Text("Movie Details")) {
                Picker("Rating", selection: $collection.ratings) {
                    ForEach(ratings, id: \.self) { rating in
                        Text(rating).tag(rating)
                    }
                }
                .pickerStyle(.menu)
                Picker("Genre", selection: $collection.genre) {
                    ForEach(genres, id: \.self) { genre in
                        Text(genre).tag(genre)
                    }
                }
                .pickerStyle(.menu)
                DatePicker("Release Date", selection: $collection.releaseDate, displayedComponents: .date)
            }
            Section(header: Text("Collection")) {
                Toggle("Show collection details", isOn: $showingCollectionDetails.animation())
                if showingCollectionDetails {
                    DatePicker("Purchase Date", selection: $collection.purchaseDate, displayedComponents: .date)
                    Picker("Location", selection: $collection.locations) {
                        ForEach(locations, id: \.self) { location in
                            Text(location).tag(location)
                        }
                    }
                    .pickerStyle(.menu)
                    DatePicker("Date entered", selection: $collection.enteredDate, displayedComponents: .date)
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
        .background(Gradient(colors: darkBottom)) // Default background color for all pages
        .scrollContentBackground(.hidden)
        .navigationBarTitle(isNew ? "Add Movie" : "\(collection.movieTitle)")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if isNew {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .disabled(collection.movieTitle.isEmpty)
                }
                ToolbarItemGroup {
                    Button("Cancel", role: .cancel) {
                        modelContext.delete(collection)
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
                            modelContext.delete(collection)
                            dismiss()
                        }
                    }
                }
                ToolbarItemGroup() {
                    Button("Update") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .disabled(collection.movieTitle.isEmpty)
                }
                
            }
        }
    }
}

#Preview("Movie Detail") {
    NavigationStack {
        MovieDetail(collection: CollectionData.shared.collection)
    }
    .modelContainer(CollectionData.shared.modelContainer)
}

#Preview("New Movie") {
    NavigationStack {
        MovieDetail(collection: CollectionData.shared.collection, isNew: true)
            .navigationBarTitle("New Movie")
            .navigationBarTitleDisplayMode(.large)
    }
    .frame(maxHeight: .infinity)
}
