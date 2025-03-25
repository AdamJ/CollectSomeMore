//
//  HowTo.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/24/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct HowToDelete: View {
    var body: some View {
        VStack(spacing: Constants.SpacerXLarge) {
            Text("How to Delete Movies")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(Color.red)
                .padding(.bottom)
                .padding(.top, Constants.SpacerXLarge)
            Spacer()
        }
        .padding()
    }
}

#Preview("Delete View") {
    HowToDelete()
        .navigationTitle("How To Delete")
        .background(Gradient(colors: transparentGradientInverse))
        .frame(maxHeight: .infinity)
}
