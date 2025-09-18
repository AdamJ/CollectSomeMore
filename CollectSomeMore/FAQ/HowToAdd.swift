//
//  HowToAdd.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/24/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct HowToAdd: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
//            CustomToolbar(
//                title: "How to Add Items",
//                leadingButtonImage: "arrow.backward.circle.fill"
//            )
            
            List {
                Section {
                    Label("Tap the plus (+) button in the top right corner of the screen.", systemImage: "1.square")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Label("Enter the title of the game or movie.", systemImage: "2.square")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Label("Include any details using the optional fields.", systemImage: "3.square")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Label("Tap 'Save' to add the movie or game to your library.", systemImage: "4.square")
                        .frame(maxWidth: .infinity, alignment: .leading)
                } header: {
                    VStack(alignment: .center, spacing: Sizing.SpacerSmall) {
                        Text("Basic")
                            .padding(.vertical, Sizing.SpacerXSmall)
                            .padding(.horizontal, Sizing.SpacerMedium)
                            .background(Colors.primaryMaterial)
                            .foregroundColor(Colors.inverseOnSurface)
                            .bodyBoldStyle()
                    }
                    .cornerRadius(Sizing.SpacerMedium)
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Title")
                            .captionStyle()
                            .padding(.trailing, Sizing.SpacerSmall)
                        Text("The title of the movie.")
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Genre")
                            .captionStyle()
                            .padding(.trailing, Sizing.SpacerSmall)
                        Text("What type of game it is. For example, RPG, FPS, strategy, etc.")
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Rating")
                            .captionStyle()
                        Text("What rating is either on the outside of the box or included in the online description.")
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Console")
                            .captionStyle()
                        Text("What video game console it is compatible with. For this, you could also consider who is the manufacturer.")
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("System")
                            .captionStyle()
                        VStack {
                            Text("The specific system that the game is compatible with. This could also be the system that it was first released on.")
                            Text("Note: not all systems are listed here, only the more popular ones. If one is missing that you would like added, let me know!")
                                .captionStyle()
                        }
                    }

                } header: {
                    VStack(alignment: .center, spacing: Sizing.SpacerSmall) {
                        Text("Game Collection")
                            .padding(.vertical, Sizing.SpacerXSmall)
                            .padding(.horizontal, Sizing.SpacerMedium)
                            .background(Colors.primaryMaterial)
                            .foregroundColor(Colors.inverseOnSurface)
                            .bodyBoldStyle()
                    }
                    .cornerRadius(Sizing.SpacerMedium)
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Movie Title")
                            .captionStyle()
                        Text("The title of the movie.")
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Rating")
                            .captionStyle()
                        Text("What rating is either on the outside of the box or included in the online description.")
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Genre")
                            .captionStyle()
                        Text("What type of movie it is. For example, Animated, Fantasy, Superhero, etc.")
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Release Date")
                            .captionStyle()
                        Text("When the movie was released to streaming or for purchase.")
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Location")
                            .captionStyle()
                        Text("Where, in your collection, the movie is located.")
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Purchase Date")
                            .captionStyle()
                        Text("When you purchased the movie for your collection.")
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Date Entered")
                            .captionStyle()
                        Text("When the movie was added to your collection.")
                        Text("Note: this is a non-editable field.")
                            .font(.caption)
                    }
                } header: {
                    VStack(alignment: .center, spacing: Sizing.SpacerSmall) {
                        Text("Movie Collection")
                            .padding(.vertical, Sizing.SpacerXSmall)
                            .padding(.horizontal, Sizing.SpacerMedium)
                            .background(Colors.primaryMaterial)
                            .foregroundColor(Colors.inverseOnSurface)
                            .bodyBoldStyle()
                    }
                    .cornerRadius(Sizing.SpacerMedium)
                }
            }
            .listRowSeparator(Visibility.hidden, edges: .all)
            .padding(.top, 8)
            .scrollContentBackground(.hidden)
            .background(Colors.surfaceLevel)
            .navigationTitle("How do I add items?")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Colors.secondaryContainer, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark)
        }
        .background(Colors.primaryMaterial)
    }
}

#Preview("How To Add") {
    HowToAdd()
}
