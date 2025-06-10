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
        VStack(spacing: 0) {
            Text("How to add items to your collections")
                .titleStyle()
            List {
                Label("Tap the plus (+) button in the top right corner of the screen.", systemImage: "1.square")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Label("Enter the title of the game or movie.", systemImage: "2.square")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Label("Include any details using the optional fields.", systemImage: "3.square")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Label("Tap 'Save' to add the movie or game to your library.", systemImage: "4.square")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                DisclosureGroup("Games") {
                    VStack {
                        List {
                            Group {
                                Text("Title")
                                    .bodyBoldStyle()
                                    .padding(.trailing, Sizing.SpacerSmall)
                                Text("The title of the movie.")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Group {
                                Text("Genre")
                                    .bodyBoldStyle()
                                    .padding(.trailing, Sizing.SpacerSmall)
                                Text("What type of game it is. For example, RPG, FPS, strategy, etc.")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Group {
                                Text("Rating")
                                    .bodyBoldStyle()
                                Text("What rating is either on the outside of the box or included in the online description.")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Group {
                                Text("Console")
                                    .bodyBoldStyle()
                                Text("What video game console it is compatible with. For this, you could also consider who is the manufacturer.")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Group {
                                Text("System")
                                    .bodyBoldStyle()
                                VStack {
                                    Text("The specific system that the game is compatible with. This could also be the system that it was first released on.")
                                    Text("Note: not all systems are listed here, only the more popular ones. If one is missing that you would like added, let me know!")
                                        .captionStyle()
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .listStyle(.plain)
                    }
                    .frame(height: 400)
                    .padding(0)
                }
                .bodyStyle()
                .frame(maxWidth: .infinity, alignment: .leading)
                
                DisclosureGroup("Movies") {
                    VStack {
                        List {
                            Group {
                                Text("Movie Title")
                                    .bodyBoldStyle()
                                Text("The title of the movie.")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Group {
                                Text("Rating")
                                    .bodyBoldStyle()
                                Text("What rating is either on the outside of the box or included in the online description.")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Group {
                                Text("Genre")
                                    .bodyBoldStyle()
                                Text("What type of movie it is. For example, Animated, Fantasy, Superhero, etc.")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Group {
                                Text("Release Date")
                                    .bodyBoldStyle()
                                Text("When the movie was released to streaming or for purchase.")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Group {
                                Text("Location")
                                    .bodyBoldStyle()
                                Text("Where, in your collection, the movie is located.")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Group {
                                Text("Purchase Date")
                                    .bodyBoldStyle()
                                Text("When you purchased the movie for your collection.")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Group {
                                Text("Date Entered")
                                    .bodyBoldStyle()
                                Text("When the movie was added to your collection.")
                                Text("Note: this is a non-editable field.")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .listStyle(.plain)
                    }
                    .frame(height: 400)
                    .padding(0)
                }
                .bodyStyle()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .scrollContentBackground(.hidden)
        }
        .background(Colors.surfaceLevel) // list
    }
}

#Preview("How To Add") {
    HowToAdd()
}
