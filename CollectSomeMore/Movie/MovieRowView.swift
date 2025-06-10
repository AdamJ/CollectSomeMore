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
        HStack {
            VStack(alignment: .leading, spacing: Sizing.SpacerXSmall) {
//                if UIDevice.current.userInterfaceIdiom == .pad {
                Text(movieCollection.movieTitle ?? "")
                    .foregroundColor(.onSurface)
                    .bodyBoldStyle()
                    .lineLimit(1)
                HStack(spacing: Sizing.SpacerMedium) {
                    // Show Game Collection Status Badge
                    if movieCollection.isWatched == true {
                        Image(systemName: "checkmark.seal.fill")
                            .padding(.top, Sizing.SpacerXSmall)
                            .padding(.trailing, Sizing.SpacerXSmall)
                            .padding(.bottom, Sizing.SpacerXSmall)
                            .padding(.leading, Sizing.SpacerXSmall)
                            .foregroundStyle(Color.green)
                            .frame(width: 16, height: 16)
                    } else {
                        Image(systemName: "seal.fill")
                            .padding(.top, Sizing.SpacerXSmall)
                            .padding(.trailing, Sizing.SpacerXSmall)
                            .padding(.bottom, Sizing.SpacerXSmall)
                            .padding(.leading, Sizing.SpacerXSmall)
                            .foregroundStyle(Color.orange)
                            .frame(width: 16, height: 16)
                    }
                    Text(movieCollection.platform ?? "")
                        .foregroundColor(.onSurfaceVariant)
                        .captionStyle()
                        .lineLimit(1)
//                  if UserInterfaceSizeClass.compact == horizontalSizeClass {

//                  if UIDevice.current.userInterfaceIdiom == .pad {
                    if movieCollection.ratings == nil {
                        
                    } else {
                        Text(movieCollection.ratings ?? "")
                            .foregroundStyle(colors[movieCollection.ratings ?? "", default: .black])
                            .captionStyle()
                            .fontWeight(.bold)
                    }
                }
            }
            .padding(.vertical, Sizing.SpacerSmall)
            
            Spacer()
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
