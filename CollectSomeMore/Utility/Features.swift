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
    @Environment(\.colorScheme) private var colorScheme
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
                                        .foregroundStyle(.black)
                                    Text("\(movieCollections.count)")
                                        .largeTitleStyle()
                                        .foregroundStyle(.black)
                                }
                                .frame(maxWidth: .infinity, minHeight: 150, alignment: .center)
                                .foregroundStyle(.secondary)
//                                .background(Colors.chipAlt)
                                .background(
                                    Image("AccentRadialBackground")
                                        .resizable()
                                        .scaledToFill()
                                    )
                                .cornerRadius(16)
                                .shadow(color: shadowColor(), radius: 4, x: 0, y: 4)
                                
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
//                                .background(Colors.chip)
                                .background(
                                    Image("AccentRadialBackground")
                                        .resizable()
                                        .scaledToFill()
                                    )
                                .cornerRadius(16)
                                .shadow(color: shadowColor(), radius: 4, x: 0, y: 4)
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
    // Helper Function to determine shadow color
    private func shadowColor() -> Color {
        if colorScheme == .dark {
            return .boxShadow  // Shadow color for dark mode
        } else {
            return .boxShadow  // Shadow color for light mode
        }
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
        return newestMovie?.location ?? "No Location Available"
    }
    var newestMovieRating: String {
        return newestMovie?.rating ?? "No Rating Available"
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
    @Environment(\.colorScheme) private var colorScheme
    
    let title: String
    let valueOne: String
    let valueTwo: String
    let iconName: String
    let total: String

    var body: some View {
        ZStack {
            Image("BlueRadialBackground")
                .resizable()
                .scaledToFill()
                .clipped()
                .cornerRadius(Sizing.SpacerMedium)
                .shadow(color: shadowColor(), radius: 4, x: 0, y: 4)
                
            Rectangle()
                .fill(Color.clear)
            
            VStack(alignment: .leading, spacing: Sizing.SpacerNone) {
                HStack(alignment: .center, spacing: Sizing.SpacerSmall) {
                    Text(title)
                        .bodyBoldStyle()
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(alignment: .center, spacing: Sizing.SpacerNone) {  }
                    .padding(0)
                }
                .padding(.leading, Sizing.SpacerMedium)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: Sizing.SpacerNone) {
                    HStack(alignment: .center, spacing: 4) {
                        Text(valueOne)
                            .title2Style()
                            .fontWeight(.regular)
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(2)
                    }
                    .padding(Sizing.SpacerMedium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(valueTwo)
                        .title2Style()
                        .fontWeight(.regular)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(2)
                }
                .padding(0)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .frame(minWidth: 200, maxWidth: .infinity)
        .frame(height: 100)
        .padding(.vertical, Sizing.SpacerSmall)
    }
    // Helper Function to determine shadow color
    private func shadowColor() -> Color {
        if colorScheme == .dark {
            return .boxShadow  // Shadow color for dark mode
        } else {
            return .boxShadow  // Shadow color for light mode
        }
    }
}

#Preview {
    FeatureCallout()
    FeatureCard(iconName: "info.circle.fill", description: "Overview of your collections.")
        .padding()
}
