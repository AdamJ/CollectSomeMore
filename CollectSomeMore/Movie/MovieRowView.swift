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
    @Bindable var movieCollection: MovieCollection
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Sizing.SpacerXSmall) {
                Text(movieCollection.movieTitle ?? "")
                    .foregroundColor(.onSurface)
                    .bodyBoldStyle()
                    .lineLimit(1)
                HStack(spacing: Sizing.SpacerMedium) {
                    if movieCollection.isWatched == true {
                        Image(systemName: "checkmark.seal.fill")
                            .padding(.top, Sizing.SpacerXSmall)
                            .padding(.trailing, Sizing.SpacerXSmall)
                            .padding(.bottom, Sizing.SpacerXSmall)
                            .padding(.leading, Sizing.SpacerXSmall)
                            .foregroundStyle(Color.blue)
                            .frame(width: 16, height: 16)
                    } else {
                        Image(systemName: "seal.fill")
                            .padding(.top, Sizing.SpacerXSmall)
                            .padding(.trailing, Sizing.SpacerXSmall)
                            .padding(.bottom, Sizing.SpacerXSmall)
                            .padding(.leading, Sizing.SpacerXSmall)
                            .foregroundStyle(Color.gray)
                            .frame(width: 16, height: 16)
                    }
                    if movieCollection.rating == nil {
                        
                    } else {
                        Text(movieCollection.rating ?? "")
                            .foregroundStyle(.onSurfaceVariant)
                            .captionStyle()
                    }
                    Text(movieCollection.platform ?? "")
                        .foregroundColor(.onSurfaceVariant)
                        .captionStyle()
                        .lineLimit(1)
                }
            }
            .padding(.vertical, Sizing.SpacerSmall)
            
            Spacer()
        }
        .background(Color.clear)
    }
}

#Preview("Movie Row") {
    let sampleMovie = MovieCollection(
            id: UUID(),
            movieTitle: "Warriors of the Wind",
            rating: "G",
            genre: "Animated",
            studio: "Studio Ghibli",
            platform: "None",
            releaseDate: .now,
            purchaseDate: .now,
            location: "Storage",
            enteredDate: .now,
            notes: "One of my favorite movies.",
        )
        return MovieRowView(movieCollection: sampleMovie)
            .modelContainer(for: [MovieCollection.self])
}
