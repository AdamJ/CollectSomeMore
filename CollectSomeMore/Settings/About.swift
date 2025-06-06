//
//  About.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/21/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    func getVersionNumber() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "Unknown"
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    HStack {
                        Image("Animoji")
                            .resizable()
                            .frame(width: 72, height: 72)
                        VStack {
                            Text("Created by")
                                .bodyStyle()
                            Text("\(Text("[Adam Jolicoeur](https://www.adamjolicoeur.com/about/)"))")
                                .linkStyle()
                        }
                        VStack {
                            Text("Games and Things is a collection app to help manage all of the games and other things that you collect. I hope you enjoy it!")
                                .lineLimit(nil)
                                .frame(maxWidth: .infinity)
                                .frame(height: 80)
                                .padding(0)
                                .bodyStyle()
                            
                            HStack(alignment: .top) { // Assistive Chips
                                HStack(alignment: .center, spacing: Sizing.SpacerNone) { // Chip
                                    BadgeItem(
                                        label: "\(getVersionNumber())",
                                        imageName: "info-circle"
                                    )
                                }
                                .padding(0)
                                .background(Colors.surfaceContainerLow)
                                .cornerRadius(16)
                                
                                HStack(alignment: .center, spacing: Sizing.SpacerNone) { // Chip
                                    BadgeItem(
                                        label: "GitHub",
                                        imageName: "github"
                                    )
                                }
                                .padding(0)
                                .background(Colors.surfaceContainerLow)
                                .cornerRadius(16)
                                
                                HStack(alignment: .center, spacing: Sizing.SpacerNone) { // Chip
                                    BadgeItem(
                                        label: "BlueSky",
                                        imageName: "bluesky"
                                    )
                                }
                                .padding(0)
                                .background(Colors.surfaceContainerLow)
                                .cornerRadius(16)
                                
                            }
                        }
                    }
                    .listRowBackground(Colors.surfaceLevel)
                    
                    Section(header: Text("FAQ")) {
                        NavigationLink(destination: HowToAdd()) {
                            Image(systemName: "plus.circle")
                            Text("How do I add items?")
                        }
                        NavigationLink(destination: HowToDelete()) {
                            Image(systemName: "minus.circle")
                            Text("How do I remove items?")
                        }
                        NavigationLink(destination: WhereIsDataStored()) {
                            Image(systemName: "swiftdata")
                            Text("Where is my data stored?")
                        }
                    }
                    .listRowBackground(Colors.surfaceLevel)
                    .bodyStyle()
                }
                .background(Colors.surfaceLevel) // list background
                .scrollContentBackground(.visible)
            }
            .foregroundStyle(Colors.onSurface)
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button("Close", role: .cancel) {
                        dismiss()
                    }
                    .bodyStyle()
                }
            }
        }
    }
}

#Preview {
    AboutView()
}
