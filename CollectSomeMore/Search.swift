//
//  Search.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 10/8/24.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Movie.title) private var movies: [Movie]
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredMovies) { movie in
                    NavigationLink {
                        MovieDetail(movie: movie)
                    } label: {
                        Text(movie.title)
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .toolbar {
            ToolbarItemGroup {
                Button("Save") {
                    dismiss()
                }
            }
        }
    }
    private var filteredMovies: [Movie] {
        if searchText.isEmpty {
            return movies
        } else {
            return movies.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

#Preview {
    SearchView()
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .modelContainer(MovieData.shared.modelContainer)
}
