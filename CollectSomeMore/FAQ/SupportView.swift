//
//  SupportView.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 6/9/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI
import SwiftData
import WebKit

struct SupportView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Need Help?")
                .titleStyle()
                .padding(.top, Sizing.SpacerLarge)
                .padding(.horizontal, Sizing.SpacerMedium)
            List {
                Section(header: Text("Submit Feedback")) {
                    Text("Your feedback is important to me! If you encounter any issues or have suggestions for new features, please don't hesitate to reach out.")
                        .bodyStyle()
                        .padding(.bottom, Sizing.SpacerSmall)
                }
                Section(header: Text("Reach Out Through GitHub ")) {
                    HStack {
                        Image("github")
                        Link("Submit an Issue",
                             destination: URL(string: "https://github.com/AdamJ/CollectSomeMore/issues/new?template=bug_report.md")!)
                        .bodyStyle()
                    }
                    HStack {
                        Image("github")
                        Link("Submit a Feature Request",
                             destination: URL(string: "https://github.com/AdamJ/CollectSomeMore/issues/new?template=feature_request.md")!)
                        .bodyStyle()
                    }
                }
                Section(header: Text("Other Ways to Contact Me")) {
                    Text("If you prefer not to use GitHub, you can also reach out via email or visit my website.")
                        .bodyStyle()
                        .padding(.bottom, Sizing.SpacerSmall)
                    HStack {
                        Image(systemName: "tray.and.arrow.up")
                        Link("Contact Me",
                             destination: URL(string: "https://www.adamjolicoeur.com/contact/")!)
                        .bodyStyle()
                    }
                    HStack {
                        Image(systemName: "hand.raised")
                        Link("Privacy Policy",
                             destination: URL(string: "https://www.adamjolicoeur.com/apps/collectsomemore/privacy/")!)
                        .bodyStyle()
                    }
                }
            }
            .listRowSeparator(Visibility.hidden, edges: .all)
            .padding(.top, 8)
            .scrollContentBackground(.hidden)
            .background(Colors.surfaceLevel)
            .navigationTitle("Support")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Colors.secondaryContainer, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark)
        }
        .background(Colors.surfaceLevel)
    }
}

#Preview("Support View") {
    SupportView()
}
