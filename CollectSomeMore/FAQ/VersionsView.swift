//
//  VersionsView.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 6/7/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI
import SwiftData
import WebKit

struct VersionsView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack {
            WebView(url: "https://blog.adamjolicoeur.com/applications/releases/")
        }
        .bodyStyle()
        .navigationBarTitle("Release Notes")
    }
}

#Preview("Versions View") {
    VersionsView()
}
