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
                    Text("Welcome!")
                        .font(.custom("Oswald-Regular", size: 24))
                        .multilineTextAlignment(.center)
                        .fontWeight(.semibold)
                    
                    FeatureCard(iconName: "info.circle.fill", description: "Overview of your collections.")
                    
                    Spacer()
                }
                .padding()
                .background(Gradient(colors: darkBottom))
                .toolbar {
                    ToolbarItemGroup(placement: .secondaryAction) {
                        NavigationLink(destination: AboutView()) {
                            Text("About")
                        }
                    }
                }
            }
        }
    }
}
