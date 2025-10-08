//
//  HomeView.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 10/8/24.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @AppStorage(.settingsUserNameKey)
    private var userName: String = ""
    
    var body: some View {
        ViewThatFits(in: .vertical) {
            VStack(spacing: Sizing.SpacerMedium) {
                if userName.isEmpty {
                    Text("Collect Some More")
                        .titleStyle()
                        .foregroundStyle(.onSurface)
                        .multilineTextAlignment(.center)
                    
                    Text("Manage your collections of games, movies, and more.")
                        .subtitleStyle()
                        .foregroundStyle(.onSurface)
                        .multilineTextAlignment(.center)
                } else {
                    Text("Welcome back, \(userName).")
                        .titleStyle()
                    Text("You can manage your collections of games, movies, and more.")
                }
                
                VStack(alignment: .leading, spacing: Sizing.SpacerSmall) {
                    FeatureCallout()
                }
                
                FeatureCard(iconName: "info.circle.fill", description: "Overview of your collections.")
                
                Spacer()
            }
            .padding(.horizontal, Sizing.SpacerMedium)
        }
        .bodyStyle()
        .background(Color.surfaceLevel)
    }
}

#Preview("Home View") {
    HomeView()
}
