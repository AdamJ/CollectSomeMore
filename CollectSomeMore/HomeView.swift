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
        NavigationStack {
            ViewThatFits(in: .vertical) {
                VStack(spacing: Sizing.SpacerMedium) {
                    if userName.isEmpty {
                        Text("Collect Some More")
                            .titleStyle()
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("Manage your collections of games, movies, and more.")
                            .subtitleStyle()
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                    } else {
                        Text("Welcome back, \(userName).")
                            .titleStyle()
                    }
                    
                    VStack(alignment: .leading, spacing: Sizing.SpacerSmall) {
                        FeatureCallout()
                    }
                    
                    FeatureCard(iconName: "info.circle.fill", description: "Overview of your collections.")
                    
                    Spacer()
                }
                .padding(.horizontal, Sizing.SpacerMedium)
                .background(
                    Image("swirlBackgroundBlue"))
            }
        }
    }
}

#Preview("Home View") {
    HomeView()
}
