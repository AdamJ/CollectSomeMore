//
//  Features.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/22/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//
import SwiftUI
import SwiftData

struct FeatureCallout: View {
    @Query() private var movieCollections: [MovieCollection]
    @Query() private var gameCollections: [GameCollection] // Add query for games
    
    var body: some View {
        VStack(alignment: .center, spacing: Sizing.SpacerNone) {
            HStack(alignment: .top, spacing: Sizing.SpacerMedium) {
                Grid(horizontalSpacing: Sizing.SpacerMedium, verticalSpacing: Sizing.SpacerMedium) {
                    GridRow {
                        VStack(alignment: .center, spacing: Sizing.SpacerNone) {
                            HStack(alignment: .top, spacing: Sizing.SpacerMedium) {
                                VStack { // Leading Image
                                    Text("Movies")
                                        .title2Style()
                                        .foregroundStyle(.onSurface)
                                    Text("\(movieCollections.count)")
                                        .largeTitleStyle()
                                        .foregroundStyle(.onSurface)
                                }
                                .frame(maxWidth: .infinity, minHeight: 150, alignment: .center)
                                .foregroundStyle(.secondary)
                                .background(Gradient(colors: cardGradient))
                                .cornerRadius(16)
                                
                                VStack { // Leading Image
                                    Text("Games")
                                        .title2Style()
                                        .foregroundStyle(.onSurface)
                                    Text("\(gameCollections.count)")
                                        .largeTitleStyle()
                                        .foregroundStyle(.onSurface)
                                }
                                .frame(maxWidth: .infinity, minHeight: 150, alignment: .center)
                                .foregroundStyle(.secondary)
                                .background(Gradient(colors: cardGradient))
                                .cornerRadius(16)
                            }
                        }
                    }
                }
                .padding(Sizing.SpacerNone)
                .frame(alignment: .top)
                .truncationMode(.tail)
                .lineLimit(1)
            }
        }
        .padding(.horizontal, Sizing.SpacerSmall)
    }
}

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
        return newestGame?.system ?? "No Console Available"
    }
    var newestGameRating: String {
        return newestGame?.rating ?? "No Rating Available"
    }

    var body: some View {
        Grid(horizontalSpacing: Sizing.SpacerMedium, verticalSpacing: Sizing.SpacerMedium) {
//            GridRow {
//                // MARK: - Total Count
//                FeatureItem(
//                    title: "Collections",
//                    valueOne: "Movies: \(movieCollections.count)",
//                    valueTwo: "Games: \(gameCollections.count)",
//                    iconName: "folder.fill.badge.plus",
//                    total: "\(gameCollections.count + movieCollections.count)"
//                )
//            }
//            
//            GridRow {
//                // MARK: - Total Count
//                FeatureItem(
//                    title: "Movies",
//                    valueOne: newestMovie?.movieTitle ?? "No Movies",
//                    valueTwo: "Movies: \(movieCollections.count)",
//                    iconName: "folder.fill.badge.plus",
//                    total: "\(gameCollections.count + movieCollections.count)"
//                )
//            }

            GridRow {
                // MARK: - Latest Movie Addition
                FeatureItem(
                    title: "Latest Movie",
                    valueOne: newestMovie?.movieTitle ?? "No Movies",
                    valueTwo: "",
                    iconName: "movieclapper.fill",
                    total: "\(newestMovieRating)"
                )
            }
            
            GridRow {
                // MARK: - Latest Movie Addition
                FeatureItem(
                    title: "Latest Game",
                    valueOne: newestGame?.gameTitle ?? "No Games",
                    valueTwo: "",
                    iconName: "gamecontroller.fill",
                    total: "\(newestGameRating)"
                )
            }
        }
        .padding(Sizing.SpacerNone)
        .frame(alignment: .top)
        .truncationMode(.tail)
        .lineLimit(1)
    }
}

// MARK: - Helper Subview for a Feature Item
struct FeatureItem: View {
    let title: String
    let valueOne: String
    let valueTwo: String
    let iconName: String
    let total: String

    var body: some View {
        VStack(alignment: .center, spacing: Sizing.SpacerNone) {
            HStack(alignment: .top, spacing: Sizing.SpacerMedium) {
//                HStack(alignment: .top, spacing: Sizing.SpacerSmall) { // Trailing Element
//                    Text(total)
//                        .bodyBoldStyle()
//                        .padding(Sizing.SpacerSmall)
//                }
//                .overlay(
//                RoundedRectangle(cornerRadius: 8)
//                    .stroke(Colors.onSecondaryContainer, lineWidth: 2)
//                )
//                .padding(Sizing.SpacerNone)
//                .frame(height: 48, alignment: .topLeading)
//                .frame(maxWidth: 48)
                ZStack { // Leading Image
                }
                .frame(width: 80, height: 80)
                .background(
                    Image(systemName: iconName)
                        .title2Style()
                        .foregroundColor(Color.onSurface)
                )
                .aspectRatio(contentMode: .fill)
                .frame(width: 32, height: 32, alignment: .center)
                .clipped()
                
                VStack(alignment: .leading, spacing: Sizing.SpacerNone) { // Content Element
                    HStack(alignment: .center, spacing: Sizing.SpacerSmall) { // Heading Block
                        Text(title)
                            .bodyBoldStyle()
                            .foregroundColor(Colors.onSurface)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(alignment: .center, spacing: Sizing.SpacerNone) {  } // Right side of heading
                        .padding(0)
                    }
                    .padding(0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: Sizing.SpacerNone) { // Support Text
                        HStack(alignment: .center, spacing: 4) { // Details
                            Text(valueOne)
                                .title2Style()
                                .fontWeight(.regular)
                                .foregroundColor(Colors.onSurface)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(2)
                        }
                        .padding(Sizing.SpacerNone)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(valueTwo)
                            .title2Style()
                            .fontWeight(.regular)
                            .foregroundColor(Colors.onSurface)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(2)
                    }
                    .padding(0)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .padding(0)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .padding(.horizontal, Sizing.SpacerMedium)
            .padding(.vertical, Sizing.SpacerSmall)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .padding(Sizing.SpacerSmall)
        .frame(maxWidth: .infinity, alignment: .top)
        .background(Gradient(colors: cardGradient))
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
    }
}

#Preview {
    FeatureCallout()
    FeatureCard(iconName: "info.circle.fill", description: "Overview of your collections.")
        .padding()
}
