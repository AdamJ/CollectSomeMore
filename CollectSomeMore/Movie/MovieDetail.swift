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

    @State private var title: String = "Details"

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let isNew: Bool
    
    let genres = ["", "Action", "Animated", "Anime", "Comedy", "Documentary", "Drama", "Educational", "Horror", "Romance", "Sci-Fi", "Suspense","Superhero"]
//    let gameConsole = ["", "Sega Genesis", "Nintendo Switch", "PlayStation 4", "PlayStation 5", "Xbox One", "Xbox Series X|S"]
//    let figures = ["Board Game", "Book", "Movie", "Video Game"]
    let ratings = ["G", "PG", "PG-13", "R", "NR"]
//    let locations = ["Cabinet", "iTunes", "Network"]
//    let videoFormats = ["Digital", "DVD", "BluRay", "4k BluRay"]
    
    init(collection: Collection, isNew: Bool = false) {
        self.collection = collection
        self.isNew = isNew
    }
    
    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Title", text: $collection.title)
            }
            Section(header: Text("Details")) {
                Picker("Rating", selection: $collection.ratings) {
                    ForEach(ratings, id: \.self) { rating in
                        Text(rating).tag(rating)
                    }
                }
                Picker("Genre", selection: $collection.genre) {
                    ForEach(genres, id: \.self) { genre in
                        Text(genre).tag(genre)
                    }
                }
                DatePicker("Release Date", selection: $collection.releaseDate, displayedComponents: .date)
            }
            Section(header: Text("Collection")) {
                DatePicker("Purchase Date", selection: $collection.purchaseDate, displayedComponents: .date)
            }
            Section(header: Text("Other")) {
                
            }
        }
        .navigationBarTitle(isNew ? "New" : "\(collection.title)")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if isNew {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button("Save") {
                        dismiss()
                    }
                }
                ToolbarItemGroup {
                    Button("Cancel") {
                        modelContext.delete(collection)
                        dismiss()
                    }
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
                    .buttonStyle(.automatic)
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
        MovieDetail(collection: CollectionData.shared.collection, isNew: false)
            .navigationBarTitle("New Movie")
            .navigationBarTitleDisplayMode(.large)
    }
    .modelContainer(CollectionData.shared.modelContainer)
}
