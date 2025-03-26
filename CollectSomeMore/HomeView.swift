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
        VStack(spacing: 30) {
            Text("Welcome to Collection Some More!")
                .font(.title)
                .multilineTextAlignment(.center)
                .fontWeight(.semibold)
                .padding(.top, Constants.SpacerHeader)
            Text("Where your collection meets your imagination!")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.bottom)
            
            FeatureCard(iconName: "popcorn",
                        description: "Get started by adding a movie to your collection!")
            
//            FeatureCard(iconName: "gamecontroller.circle", description: "Video game collection tracking")
            
            Spacer()
        }
        .padding()
        .background(Gradient(colors: darkBottom))
    }
}

#Preview {
    HomeView()
        .frame(maxHeight: .infinity)
        .background(Gradient(colors: transparentGradient))
}
