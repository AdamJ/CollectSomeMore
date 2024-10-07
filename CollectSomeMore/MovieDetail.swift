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

    let isNew: Bool
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let genres = ["Action", "Animated", "Anime", "Comedy", "Documentary", "Drama", "Educational", "Horror", "Romance", "Sci-Fi", "Suspense","Superhero"]
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
                TextField("Movie title", text: $movie.title)
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
        HStack(alignment: .center, spacing: 0) {
            if isNew {
                Spacer()
                Button("Cancel") {
                    modelContext.delete(movie)
                    dismiss()
                }
                .buttonStyle(.automatic)
                .foregroundStyle(.text)
                Spacer()
                Button("Add", systemImage: "plus.app") {
                    dismiss()
                }
                .foregroundStyle(.success)
                Spacer()
            } else {
                Spacer()
                Button("Delete", systemImage: "trash") {
                    modelContext.delete(movie)
                    dismiss()
                }
                .buttonStyle(.automatic)
                .foregroundStyle(.error)
                Spacer()
                Button("Update", systemImage: "pencil") {
                    dismiss()
                }
                .foregroundStyle(.accent)
                Spacer()
            }
        }
        .padding(0)
        .navigationTitle(isNew ? "New Movie" : "Details")
    }
}

#Preview {
    NavigationStack {
        MovieDetail(movie: MovieData.shared.movie)
            .navigationBarTitleDisplayMode(.inline)
    }
    .modelContainer(MovieData.shared.modelContainer)
}

#Preview("New Movie") {
    NavigationStack {
        MovieDetail(movie: MovieData.shared.movie, isNew: true)
            .navigationBarTitleDisplayMode(.inline)
    }
    .modelContainer(MovieData.shared.modelContainer)
}
