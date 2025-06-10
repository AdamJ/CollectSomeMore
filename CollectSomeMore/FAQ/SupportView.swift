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
        VStack {
            WebView(url: "https://www.adamjolicoeur.com/apps/gamesandthings/support/")
        }
        .bodyStyle()
        .navigationBarTitle("Support")
    }
}

#Preview("Support View") {
    SupportView()
}
