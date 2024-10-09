//
//  MovieDetail.swift
//  CollectSomeMore
//  Created by Adam Jolicoeur on 6/7/24.
//
//  For Adding a New Movie to the list
//

import SwiftUI

struct MovieDetail: View {
    @Bindable var movie: Movie
    @State private var showingOptions = false
    @State private var selection = "None"

    @State private var title: String = "Details"

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let isNew: Bool
    
    let genres = ["Action", "Animated", "Anime", "Comedy", "Documentary", "Drama", "Educational", "Horror", "Romance", "Sci-Fi", "Suspense","Superhero"]
//    let figures = ["Board Game", "Book", "Movie", "Video Game"]
//    let ratings = ["G", "PG", "PG-13", "R", "NR"]
//    let locations = ["Cabinet", "iTunes", "Network"]
//    let videoFormats = ["Digital", "DVD", "BluRay", "4k BluRay"]
    
    init(movie: Movie, isNew: Bool = false) {
        self.movie = movie
        self.isNew = isNew
    }
    
    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Title", text: $movie.title)
            }
            Section(header: Text("Details")) {
                Picker("Genre", selection: $movie.genre) {
                    ForEach(genres, id: \.self) { genre in
                        Text(genre).tag(genre)
                    }
                }
                DatePicker("Release Date", selection: $movie.releaseDate, displayedComponents: .date)
            }
            Section(header: Text("Collection")) {
                DatePicker("Purchase Date", selection: $movie.purchaseDate, displayedComponents: .date)
            }
        }
        .navigationTitle(isNew ? "New" : "\(movie.title)")
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
                        modelContext.delete(movie)
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
                        Button("Confirm") {
                            modelContext.delete(movie)
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
        MovieDetail(movie: MovieData.shared.movie)
    }
    .modelContainer(MovieData.shared.modelContainer)
}

#Preview("New Movie") {
    NavigationStack {
        MovieDetail(movie: MovieData.shared.movie, isNew: true)
            .navigationTitle("New Movie")
            .navigationBarTitleDisplayMode(.large)
    }
    .modelContainer(MovieData.shared.modelContainer)
}
