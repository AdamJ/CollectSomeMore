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
        VStack(spacing: Sizing.SpacerSmall) {
            Text("How to Add Games and Movies to Your Collections")
                .font(.title)
                .fontWeight(.semibold)

            List {
                Text("Add an item")
                    .fontWeight(.semibold)
                Section(header: Text("General")) {
                    Group {
                        Text("1. Tap the plus (+) button in the top right corner of the screen.")
                            .listRowSeparator(Visibility.visible, edges: .bottom)
                        Text("2. Enter the title of the game or movie")
                            .listRowSeparator(Visibility.visible, edges: .bottom)
                        Text("3. Include any details using the optional fields")
                            .listRowSeparator(Visibility.visible, edges: .bottom)
                        Text("4. Tap 'Save' to add the movie or game to your library")
                            .listRowSeparator(Visibility.visible, edges: .bottom)
                    }
                }
                Text("Explanation of optional fields")
                    .fontWeight(.semibold)
                
                Section(header: Text("Games")) {
                    VStack(alignment: .leading) {
                        Text("Game Title")
                            .fontWeight(.semibold)
                            .padding(.trailing, Sizing.SpacerSmall)
                        Text("The title of the game.")
                    }
                    .listRowSeparator(Visibility.visible, edges: .bottom)
                    
                    VStack(alignment: .leading) {
                        Text("Genre")
                            .fontWeight(.semibold)
                            .padding(.trailing, Sizing.SpacerSmall)
                        Text("What type of game it is. For example, RPG, FPS, strategy, etc.")
                    }
                    .listRowSeparator(Visibility.visible, edges: .bottom)
                    
                    VStack(alignment: .leading) {
                        Text("Rating")
                            .fontWeight(.semibold)
                            .padding(.trailing, Sizing.SpacerSmall)
                        Text("What rating is either on the outside of the box or included in the online description.")
                    }
                    .listRowSeparator(Visibility.visible, edges: .bottom)
                    
                    VStack(alignment: .leading) {
                        Text("Console")
                            .fontWeight(.semibold)
                            .padding(.trailing, Sizing.SpacerSmall)
                        Text("What video game console it is compatible with. For this, you could also consider who is the manufacturer.")
                    }
                    .listRowSeparator(Visibility.visible, edges: .bottom)
                    
                    VStack(alignment: .leading) {
                        Text("System")
                            .fontWeight(.semibold)
                            .padding(.trailing, Sizing.SpacerSmall)
                        VStack {
                            Text("The specific system that the game is compatible with. This could also be the system that it was first released on.")
                            Text("Note: not all systems are listed here, only the more popular ones. If one is missing that you would like added, let me know!")
                                .font(.caption)
                        }
                    }
                    .listRowSeparator(Visibility.visible, edges: .bottom)
                }
                Section(header: Text("Movies")) {
                    VStack(alignment: .leading) {
                        Text("Movie Title")
                            .fontWeight(.semibold)
                            .padding(.trailing, Sizing.SpacerSmall)
                        Text("The title of the movie.")
                    }
                    .listRowSeparator(Visibility.visible, edges: .bottom)
                }
                Section(header: Text("Details")) {
                    VStack(alignment: .leading) {
                        Text("Rating")
                            .fontWeight(.semibold)
                            .padding(.trailing, Sizing.SpacerSmall)
                        Text("What rating is either on the outside of the box or included in the online description.")
                    }
                    .listRowSeparator(Visibility.visible, edges: .bottom)
                    
                    VStack(alignment: .leading) {
                        Text("Genre")
                            .fontWeight(.semibold)
                            .padding(.trailing, Sizing.SpacerSmall)
                        Text("What type of movie it is. For example, Animated, Fantasy, Superhero, etc.")
                    }
                    .listRowSeparator(Visibility.visible, edges: .bottom)
                    
                    VStack(alignment: .leading) {
                        Text("Release Date")
                            .fontWeight(.semibold)
                            .padding(.trailing, Sizing.SpacerSmall)
                        Text("When the movie was released to streaming or for purchase.")
                    }
                    .listRowSeparator(Visibility.visible, edges: .bottom)
                }
                Section(header: Text("Collection")) {
                    VStack(alignment: .leading) {
                        Text("Location")
                            .fontWeight(.semibold)
                            .padding(.trailing, Sizing.SpacerSmall)
                        Text("Where, in your collection, the movie is located.")
                    }
                    .listRowSeparator(Visibility.visible, edges: .bottom)
                    
                    VStack(alignment: .leading) {
                        Text("Purchase Date")
                            .fontWeight(.semibold)
                            .padding(.trailing, Sizing.SpacerSmall)
                        Text("When you purchased the movie for your collection.")
                    }
                    .listRowSeparator(Visibility.visible, edges: .bottom)
                    
                    VStack(alignment: .leading) {
                        Text("Date Entered")
                            .fontWeight(.semibold)
                            .padding(.trailing, Sizing.SpacerSmall)
                        Text("When the movie was added to your collection.")
                        Text("Note: this is a non-editable field.")
                            .font(.caption)
                    }
                    .listRowSeparator(Visibility.visible, edges: .bottom)
                }
            }
            .scrollContentBackground(.hidden)
            Spacer()
        }
        .padding()
    }
}

#Preview("How To Add") {
    HowToAdd()
        .navigationTitle("How To")
        .background(Gradient(colors: transparentGradientInverse))
        .frame(maxHeight: .infinity)
}
