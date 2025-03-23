//
//  Features.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/22/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//
import SwiftUI


struct FeatureCard: View {
    let iconName: String
    let description: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.largeTitle)
                .frame(width: 50)
                .padding(.trailing, 10)
            
            Text(description)
                .fontWeight(.semibold)
            
            Spacer()
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 100)
                .foregroundStyle(.gradientBottom)
                .shadow(radius: 10)
                .opacity(0.5)
                .brightness(-0.2)
        }
        .foregroundStyle(.white)
    }
}


#Preview {
    FeatureCard(iconName: "person.2.crop.square.stack.fill",
                description: "A multiline description about a feature paired with the image on the left.")
}
