//
//  MovieDetail.swift
//  CollectSomeMore
//
//  Created by Adam Jolicoeur on 6/7/24.
//

import SwiftUI

struct MovieDetail: View {
    @Bindable var movie: Movie
    @State private var selectedImage: UIImage?
    @State private var selectedImageData: Data?

    let isNew: Bool
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let genres = ["Action", "Comedy", "Drama", "Horror", "Romance", "Sci-Fi", "Superhero"]
    
    init(movie: Movie, isNew: Bool = false) {
        self.movie = movie
        self.isNew = isNew
    }
    
    var body: some View {
        Form {
            TextField("Movie title", text: $movie.title)
            
            DatePicker("Release Date", selection: $movie.releaseDate, displayedComponents: .date)
            DatePicker("Purchase Date", selection: $movie.purchaseDate, displayedComponents: .date)
            
            Picker("Genre", selection: $movie.genre) {
                ForEach(genres, id: \.self) { genre in
                    Text(genre).tag(genre)
                }
            }
        }
        .navigationTitle(isNew ? "New Movie" : "Movie details")
        .toolbar {
            if isNew {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        modelContext.delete(movie)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MovieDetail(movie: MovieData.shared.movie)
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
