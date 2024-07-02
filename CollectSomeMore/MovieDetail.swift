//
//  MovieDetail.swift
//  CollectSomeMore
//
//  Created by Adam Jolicoeur on 6/7/24.
//

import SwiftUI

struct MovieDetail: View {
    @Bindable var movie: Movie
    let isNew: Bool
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    init(movie: Movie, isNew: Bool = false) {
        self.movie = movie
        self.isNew = isNew
    }
    
    var body: some View {
        Form {
            TextField("Movie title", text: $movie.title)
            
            DatePicker("Release date", selection: $movie.releaseDate, displayedComponents: .date)
            Section(header: Text("Collection details")) {
                DatePicker("Purchase date", selection: $movie.purchaseDate, displayedComponents: .date)
                Label("Movie poster", systemImage: "bolt.fill")
                    .labelStyle(.titleOnly)
                AsyncImage(url: URL(string: "https://placehold.co/100x100.png")) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
            }
        }
        .navigationTitle(isNew ? "New Movie" : "Movie")
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
