//
//  HomeView.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 10/8/24.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ViewThatFits(in: .horizontal) {
                VStack(spacing: 16) {
                    Text("Games And Things")
                        .titleStyle()
                        .multilineTextAlignment(.center)
                    Text("Manage your collections of games and other items.")
                        .bodyStyle()
                    
                    FeatureCard(iconName: "info.circle.fill", description: "Overview of your collections.")
                    
                    Spacer()
                }
                .padding()
                .background(Colors.surfaceLevel)
            }
        }
    }
}

#Preview("Home View") {
    HomeView()
}
