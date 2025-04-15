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
        return newestMovie?.locations ?? "No Location Available"
    }
    var newestMovieRating: String {
        return newestMovie?.ratings ?? "No Rating Available"
    }

    // MARK: - Computed Properties for Newest Game
    var newestGame: GameCollection? {
        return gameCollections.sorted(by: { $0.enteredDate ?? Date() > $1.enteredDate ?? Date() }).first
    }
    var newestGameConsole: String {
        return newestGame?.system ?? "No Console Selected"
    }

    var body: some View {
        Grid(horizontalSpacing: Constants.SpacerMedium, verticalSpacing: Constants.SpacerMedium) {
            GridRow {
                // MARK: - Total Movie Count
                FeatureItem(
                    title: "Movies",
                    value: "\(movieCollections.count)",
                    iconName: "popcorn.circle"
                )

                // MARK: - Total Game Count
                FeatureItem(
                    title: "Games",
                    value: "\(gameCollections.count)",
                    iconName: "gamecontroller.circle.fill"
                )
            }

            GridRow {
                // MARK: - Latest Movie Addition
                FeatureItem(
                    title: "Latest Movie",
                    value: newestMovie?.movieTitle ?? "No Movies Entered",
                    iconName: "arrow.trianglehead.2.clockwise.rotate.90.circle"
                )

                // MARK: - Latest Game Addition
                FeatureItem(
                    title: "Latest Game",
                    value: newestGame?.gameTitle ?? "No Games Entered",
                    iconName: "arrow.trianglehead.2.clockwise.rotate.90.circle.fill"
                )
            }

            GridRow {
                // MARK: - Last Movie Location
                FeatureItem(
                    title: "Movie Location",
                    value: newestMovieLocation,
                    iconName: "folder.circle"
                )

                // MARK: - Last Game Console
                FeatureItem(
                    title: "Last Console",
                    value: newestGameConsole,
                    iconName: "folder.circle.fill"
                )
            }
        }
        .padding(Constants.SpacerNone)
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
            HStack() {
                Image(systemName: iconName)
                    .title2Style()
                    .foregroundColor(Color.accentColor)
                
                Text(title)
                    .bodyStyle()
                    .foregroundColor(Color.gray09)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, Constants.SpacerSmall)
            
            Text(value)
                .bodyStyle()
                .foregroundColor(Color.gray09)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(2)
        }
        .padding(Constants.SpacerMedium)
        .frame(minWidth: 150, maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: Constants.SpacerLarge)
                .fill(Color.gradientBottom.opacity(0.3))
        )
    }
}

#Preview {
    FeatureCard(iconName: "info.circle.fill", description: "Overview of your collections.")
        .padding()
}
