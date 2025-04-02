//
//  Features.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/22/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//
import SwiftUI
import SwiftData

struct FeatureCard: View {
    @Query() private var movieCollections: [MovieCollection]
    @Query() private var gameCollections: [GameCollection] // Add query for games

    let iconName: String
    let description: String

    // MARK: - Computed Properties for Newest Movie
    var newestMovie: MovieCollection? {
        return movieCollections.sorted(by: { $0.enteredDate ?? Date() > $1.enteredDate ?? Date() }).first
    }
    var newestMovieLocation: String {
        return newestMovie?.locations ?? "N/A"
    }
    var newestMovieRating: String {
        return newestMovie?.ratings ?? "N/A"
    }

    // MARK: - Computed Properties for Newest Game
    var newestGame: GameCollection? {
        return gameCollections.sorted(by: { $0.enteredDate ?? Date() > $1.enteredDate ?? Date() }).first
    }
    var newestGameConsole: String {
        return newestGame?.console ?? "N/A"
    }

    var body: some View {
        Grid(horizontalSpacing: Constants.SpacerMedium, verticalSpacing: Constants.SpacerMedium) {
            GridRow {
                // MARK: - Total Movie Count
                FeatureItem(
                    title: "Total Movies",
                    value: "\(movieCollections.count)",
                    iconName: "film.fill"
                )

                // MARK: - Total Game Count
                FeatureItem(
                    title: "Total Games",
                    value: "\(gameCollections.count)",
                    iconName: "gamecontroller.fill"
                )
            }

            GridRow {
                // MARK: - Recent Movie Addition
                FeatureItem(
                    title: "Recent Movie",
                    value: newestMovie?.movieTitle ?? "No movies yet",
                    iconName: "popcorn.circle"
                )

                // MARK: - Recent Game Addition
                FeatureItem(
                    title: "Recent Game",
                    value: newestGame?.gameTitle ?? "No games yet",
                    iconName: "gamecontroller.circle"
                )
            }

            GridRow {
                // MARK: - Last Movie Location
                FeatureItem(
                    title: "Last Movie Location",
                    value: newestMovieLocation,
                    iconName: "location.circle"
                )

                // MARK: - Last Game Console
                FeatureItem(
                    title: "Last Game Console",
                    value: newestGameConsole,
                    iconName: "location.circle.fill"
                )
            }
        }
        .padding(Constants.SpacerLarge)
        .frame(alignment: .top)
        .truncationMode(.tail)
        .lineLimit(2)
    }
}

// MARK: - Helper Subview for a Feature Item
struct FeatureItem: View {
    let title: String
    let value: String
    let iconName: String

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.SpacerSmall) {
            Image(systemName: iconName)
                .font(.custom("Oswald-Regular", size: 24))
                .foregroundColor(Color.accentColor)

            Text(title)
                .font(.custom("Oswald-Regular", size: 14))
                .foregroundColor(Color.gray09)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(value)
                .font(.custom("Oswald-Regular", size: 18))
                .foregroundColor(Color.gray09)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(Constants.SpacerMedium)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: Constants.SpacerLarge)
                .fill(Color.gradientBottom.opacity(0.3))
        )
    }
}

#Preview {
    FeatureCard(iconName: "info.circle.fill", description: "Overview of your collections.")
        .padding()
        .background(Color.gray03)
}
