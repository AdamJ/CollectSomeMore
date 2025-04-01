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
                        .font(.body)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                }
                .padding(.trailing, Constants.SpacerMedium)
                HStack {
                    let colors: [String: Color] = ["G": .backgroundGreen, "PG": .backgroundBlue, "PG-13": .backgroundOrange, "R": .backgroundRed, "NR": .gray02, "Unrated": .backgroundYellow]
                    Text(movieCollection.ratings ?? "")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.top, Constants.SpacerXSmall)
                        .padding(.trailing, Constants.SpacerSmall)
                        .padding(.bottom, Constants.SpacerXSmall)
                        .padding(.leading, Constants.SpacerSmall)
                        .background(colors[movieCollection.ratings ?? "", default: .gray01])
                        .foregroundStyle(.text)
                        .clipShape(.capsule)
                    if UserInterfaceSizeClass.compact == horizontalSizeClass {
                        LocationIconView(locations: movieCollection.locations ?? "")
                            .foregroundStyle(.text)
                    } else {
                        Text(movieCollection.locations ?? "")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.text)
                    }
                }
            }
        }
    }
}
