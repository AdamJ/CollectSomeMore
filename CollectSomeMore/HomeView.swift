//
//  HomeView.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 10/8/24.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @AppStorage(.settingsUserNameKey)
    private var userName: String = ""
    
    var body: some View {
        NavigationStack {
            ViewThatFits(in: .horizontal) {
                VStack(spacing: Sizing.SpacerMedium) {
                    
                    if userName.isEmpty {
                        Text("Collect Some More")
                            .titleStyle()
                            .multilineTextAlignment(.center)

                        Text("Manage your collections of games, movies, and more.")
                            .bodyStyle()
                    } else {
                        Text("Welcome back, \(userName).")
                            .titleStyle()
                    }
                    
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
