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
    @Query() private var collections: [Collection]
    
    let iconName: String
    let description: String
    
    var body: some View {
        if !collections.isEmpty {
            Grid() {
                GridRow {
                    VStack(alignment: .leading, spacing: Constants.SpacerSmall) {
                        Text("Number of collections")
                            .font(.footnote)
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("1")
                            .font(.title3.bold())
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(Constants.SpacerMedium)
                    .frame(alignment: .topLeading)
                    .background(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.09, green: 0.23, blue: 0.3), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.09, green: 0.23, blue: 0.3).opacity(0), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                    )
                    .cornerRadius(Constants.SpacerLarge)
                    
                    VStack(alignment: .leading, spacing: Constants.SpacerSmall) {
                        Text("Movie count")
                            .font(.footnote)
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(collections.count)")
                            .font(.title3.bold())
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(Constants.SpacerMedium)
                    .frame(alignment: .topLeading)
                    .background(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.09, green: 0.23, blue: 0.3), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.09, green: 0.23, blue: 0.3).opacity(0), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                    )
                    .cornerRadius(Constants.SpacerLarge)
                }
                // RECENT ADDITION
                GridRow {
                    VStack(alignment: .leading, spacing: Constants.SpacerSmall) {
                        Text("Recent Addition")
                            .font(.footnote)
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(collections.first?.movieTitle ?? "No data")")
                            .font(.title3.bold())
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(Constants.SpacerMedium)
                    .frame(alignment: .topLeading)
                    .background(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.09, green: 0.23, blue: 0.3), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.09, green: 0.23, blue: 0.3).opacity(0), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                    )
                    .cornerRadius(Constants.SpacerLarge)
                    
                    // AVERAGE RATING
                    VStack(alignment: .leading, spacing: Constants.SpacerSmall) {
                        Text("Last Rating")
                            .font(.footnote)
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(collections.last?.ratings ?? "No data")")
                            .font(.title3.bold())
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(Constants.SpacerMedium)
                    .frame(alignment: .topLeading)
                    .background(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.09, green: 0.23, blue: 0.3), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.09, green: 0.23, blue: 0.3).opacity(0), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                    )
                    .cornerRadius(Constants.SpacerLarge)
                }
                GridRow {
                    // RECENT LOCATION
                    VStack(alignment: .leading, spacing: Constants.SpacerSmall) {
                        Text("Last Location")
                            .font(.footnote)
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(collections.first?.locations ?? "No data")")
                            .font(.title3.bold())
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(Constants.SpacerMedium)
                    .frame(alignment: .topLeading)
                    .background(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.09, green: 0.23, blue: 0.3), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.09, green: 0.23, blue: 0.3).opacity(0), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                    )
                    .cornerRadius(Constants.SpacerLarge)
                }
            }
            .padding(.horizontal, Constants.SpacerLarge)
            .padding(.vertical, 0)
            .frame(alignment: .top)
        } else {
            Text("Add your first item to your collection to see featured details!")
                .padding(0)
        }
    }
}


#Preview {
    FeatureCard(iconName: "person.2.crop.square.stack.fill",
                description: "Describe what the app is about.")
}
