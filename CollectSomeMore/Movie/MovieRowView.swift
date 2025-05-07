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
        HStack(spacing: Sizing.SpacerNone) {
            VStack(alignment: .leading, spacing: Sizing.SpacerNone) {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    Text(movieCollection.movieTitle ?? "")
                        .foregroundColor(.onSurface)
                        .bodyBoldStyle()
                        .lineLimit(1)
                    Text(movieCollection.studio ?? "")
                        .foregroundColor(.onSurfaceVariant)
                        .captionStyle()
                        .lineLimit(1)
                } else {
                    Text(movieCollection.movieTitle ?? "")
                        .foregroundColor(.onSurface)
                        .bodyBoldStyle()
                        .lineLimit(1)
                }
            }
//                .padding(.trailing, Sizing.SpacerMedium)
            Spacer()
            HStack {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    let colors: [String: Color] = ["G": .accentPurple, "PG": .accentBlue, "PG-13": .accentOrange, "R": .accentRed, "NR": .accentGray, "Unrated": .accentYellow]
                    if movieCollection.ratings == nil {
                        
                    } else {
                        Text(movieCollection.ratings ?? "")
                            .padding(.top, Sizing.SpacerXSmall)
                            .padding(.trailing, Sizing.SpacerSmall)
                            .padding(.bottom, Sizing.SpacerXSmall)
                            .padding(.leading, Sizing.SpacerSmall)
                            .background(colors[movieCollection.ratings ?? "", default: .transparent])
                            .foregroundStyle(.oppositeText)
                            .minimalStyle()
                            .clipShape(.capsule)
                    }
                } else { }
                
                if UserInterfaceSizeClass.compact == horizontalSizeClass {
                    LocationIconView(locations: movieCollection.locations ?? "")
                        .foregroundStyle(.onSurface)
                } else {
                    Text(movieCollection.locations ?? "")
                        .bodyStyle()
                        .foregroundStyle(.onSurface)
                }
            }
        }
    }
}

#Preview("Content View") {
    let sampleMovie = MovieCollection(
            id: UUID(),
            movieTitle: "Warriors of the Wind",
            ratings: "G",
            genre: "Animated",
            studio: "Studio Ghibli",
            platform: "None",
            releaseDate: .now,
            purchaseDate: .now,
            locations: "Storage",
            enteredDate: .now,
            notes: "One of my favorite movies.",
        )
        return MovieRowView(movieCollection: sampleMovie)
            .modelContainer(for: [MovieCollection.self])
}
