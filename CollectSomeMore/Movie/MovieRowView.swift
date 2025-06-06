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
    
    let colors: [String: Color] = ["G": .accentPurple, "PG": .accentGreen, "PG-13": .accentBlue, "R": .accentRed, "NR": .black, "Unrated": .accentGray]
    
    var body: some View {
        HStack(spacing: Sizing.SpacerNone) {
            VStack(alignment: .leading, spacing: Sizing.SpacerNone) {
//                if UIDevice.current.userInterfaceIdiom == .pad {
                Text(movieCollection.movieTitle ?? "")
                    .foregroundColor(.onSurface)
                    .bodyBoldStyle()
                    .lineLimit(1)
                HStack(spacing: Sizing.SpacerMedium) {
                    Text(movieCollection.platform ?? "")
                        .foregroundColor(.onSurface)
                        .captionStyle()
                        .lineLimit(1)
                    Text(movieCollection.ratings ?? "")
                        .foregroundColor(.white)
                        .minimalStyle()
                        .frame(width: 52, height: 16)
                        .cornerRadius(16)
                        .background(colors[movieCollection.ratings ?? "", default: .transparent])
                }
            }
            .padding(.vertical, Sizing.SpacerSmall)
            
            Spacer()
            
            HStack {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    
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

#Preview("Movie Row") {
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
