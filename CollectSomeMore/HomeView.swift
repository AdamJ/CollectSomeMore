//
//  HomeView.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 10/8/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Welcome to GamesAndThings!")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom)
                .padding(.top, 100)
            
            Text("Current Feature List:")
                .font(.headline)
                .fontWeight(.semibold)
            
            FeatureCard(iconName: "popcorn",
                        description: "Movie collection tracking")
            
            FeatureCard(iconName: "gamecontroller.circle", description: "Video game collection tracking")
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    HomeView()
        .frame(maxHeight: .infinity)
        .background(Gradient(colors: gradientColors))
}
