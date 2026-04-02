//
//  FAQ.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 6/9/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct FAQView: View {
    func getVersionNumber() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "Unknown"
    }
    
    var body: some View {
        Form {
            aboutSection
        }
        .bodyStyle()
        .listRowSeparator(Visibility.hidden, edges: .all)
        .padding(.top, 8)
        .scrollContentBackground(.hidden)
        .background(Colors.surfaceLevel)
        .navigationTitle("FAQ")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Colors.secondaryContainer, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark)
    }
    
    @ViewBuilder
    private var aboutSection: some View {
        Section {
            NavigationLink(destination: HowToAdd()) {
                Image(systemName: "questionmark.circle")
                VStack(alignment: .leading, spacing: 0) {
                    Text("How do I add items?")
                        .bodyStyle()
                    Text("From game and movie collections")
                        .minimalStyle()
                }
            }
            NavigationLink(destination: HowToDelete()) {
                Image(systemName: "questionmark.circle")
                VStack(alignment: .leading, spacing: 0) {
                    Text("How do I delete items?")
                        .bodyStyle()
                    Text("From game and movie collections")
                        .minimalStyle()
                }
            }
            NavigationLink(destination: WhereIsDataStored()) {
                Image(systemName: "swiftdata")
                VStack(alignment: .leading, spacing: 0) {
                    Text("Data storage")
                        .bodyStyle()
                    Text("Data handling and privacy")
                        .minimalStyle()
                }
            }
        } header: {
            Text("Frequently Asked Questions")
                .padding(.vertical, Sizing.SpacerXSmall)
                .padding(.horizontal, Sizing.SpacerMedium)
                .background(Colors.primaryMaterial)
                .foregroundColor(Colors.inverseOnSurface)
                .bodyBoldStyle()
                .cornerRadius(Sizing.SpacerXSmall)
        } footer: {
            Text("Version \(getVersionNumber())")
                .frame(maxWidth: .infinity, alignment: .center)
                .captionStyle()
        }
    }
}

#Preview("FAQ View") {
    FAQView()
}
