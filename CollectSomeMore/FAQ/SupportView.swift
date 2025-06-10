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
            List {
                HStack {
                    Image("github")
                    Link("Create an Issue",
                         destination: URL(string: "https://github.com/AdamJ/CollectSomeMore/issues/new?template=bug_report.md")!)
                    .bodyStyle()
                }
                HStack {
                    Image("github")
                    Link("Feature Requests",
                         destination: URL(string: "https://github.com/AdamJ/CollectSomeMore/issues/new?template=feature_request.md")!)
                    .bodyStyle()
                }
                HStack {
                    Image(systemName: "envelope")
                    Link("Contact",
                         destination: URL(string: "https://www.adamjolicoeur.com/contact/")!)
                    .bodyStyle()
                }
                
            }
            .listRowSeparator(Visibility.hidden, edges: .all)
            .padding(.top, 8)
            .scrollContentBackground(.hidden)
            .background(Colors.surfaceLevel)
            .navigationTitle("Support")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Colors.secondaryContainer, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark)
        }
        .background(Colors.primaryMaterial)
    }
}

#Preview("Support View") {
    SupportView()
}
