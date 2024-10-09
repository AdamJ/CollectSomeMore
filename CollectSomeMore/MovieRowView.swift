//
//  MovieRowView.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 10/8/24.
//  Style rows for displaying movie information
//    in order to keep the main MovieList file cleaner
//

import SwiftUI
import SwiftData

struct MovieRowView: View {
    @Bindable var movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(movie.title)
                .foregroundColor(.primary)
                .font(.headline)
            HStack(spacing: 3) {
                Label(movie.genre, systemImage: "movieclapper")
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
    }
}

