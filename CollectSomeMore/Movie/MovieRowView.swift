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
        HStack(spacing: Constants.SpacerNone) {
            HStack(spacing: Constants.SpacerNone) {
                VStack(alignment: .leading, spacing: Constants.SpacerNone) {
                    Text(movieCollection.movieTitle ?? "")
                        .foregroundColor(.text)
                        .font(.custom("Oswald-SemiBold", size: 16))
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    Text(movieCollection.studio ?? "")
                        .foregroundColor(.secondary)
                        .font(.custom("Oswald-Regular", size: 14))
                        .fontWeight(.regular)
                        .lineLimit(1)
                }
                .padding(.trailing, Constants.SpacerMedium)
                Spacer()
                HStack {
                    let colors: [String: Color] = ["G": .backgroundGreen, "PG": .backgroundBlue, "PG-13": .backgroundOrange, "R": .backgroundRed, "NR": .gray02, "Unrated": .backgroundYellow]
                    if movieCollection.ratings == nil {
                        
                    } else {
                        Text(movieCollection.ratings ?? "")
                            .font(.custom("Oswald-ExtraLight", size: 14))
                            .fontWeight(.bold)
                            .padding(.top, Constants.SpacerXSmall)
                            .padding(.trailing, Constants.SpacerSmall)
                            .padding(.bottom, Constants.SpacerXSmall)
                            .padding(.leading, Constants.SpacerSmall)
                            .background(colors[movieCollection.ratings ?? "", default: .gray01])
                            .foregroundColor(.text)
                            .font(.custom("Oswald-Regular", size: 14))
                            .clipShape(.capsule)
                    }
                    if UserInterfaceSizeClass.compact == horizontalSizeClass {
                        LocationIconView(locations: movieCollection.locations ?? "")
                            .foregroundStyle(.text)
                    } else {
                        Text(movieCollection.locations ?? "")
                            .font(.custom("Oswald-ExtraLight", size: 14))
                            .fontWeight(.bold)
                            .foregroundStyle(.text)
                    }
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
            studio: "Ghibli",
            platform: "None",
            releaseDate: .now,
            purchaseDate: .now,
            locations: "Cabinet",
            enteredDate: .now,
            notes: "It is nice to have notes for the collection, just in case there are fields that do not cover certain bits of information.",
        )
        return MovieRowView(movieCollection: sampleMovie)
            .modelContainer(for: [MovieCollection.self])
}
