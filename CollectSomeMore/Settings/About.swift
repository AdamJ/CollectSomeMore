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
    func getCopyright() -> String {
        "© 2025 Adam Jolicoeur, All Rights Reserved"
    }
    func getPlatform() -> String {
        #if os(iOS)
        return "iOS"
        #elseif os(macOS)
        return "macOS"
        #else
        return "Unknown"
        #endif
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    HStack {
                        Image("Animoji")
                            .resizable()
                            .frame(width: 72, height: 72)
                        HStack {
                            Text("Created by")
                                .bodyStyle()
                            Text("\(Text("[Adam Jolicoeur](https://www.adamjolicoeur.com/about/)"))")
                                .linkStyle()
                        }
                    }
                    VStack {
                        Text("Games and Things is a collection app to help manage all of the games and other things that you collect. I hope you enjoy it!")
                            .lineLimit(nil)
                            .frame(maxWidth: .infinity)
                            .frame(height: 80)
                            .padding(0)
                            .bodyStyle()
                    }
                            
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
                    HStack {
                        Image(systemName: "info.circle")
                        Text("Copyright \(Text("\(getCopyright())"))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, Sizing.SpacerSmall)
                    }
                    HStack {
                        Image(systemName: "macbook.and.iphone")
                        Text("Platform: \(Text("\(getPlatform())"))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .listRowSeparator(Visibility.hidden, edges: .all)
                .padding(.top, 8)
                .scrollContentBackground(.hidden)
                .background(Colors.surfaceLevel)
                .navigationTitle("About")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Colors.secondaryContainer, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark)
            }
            .background(Colors.primaryMaterial)
        }
    }
}

#Preview {
    AboutView()
}
