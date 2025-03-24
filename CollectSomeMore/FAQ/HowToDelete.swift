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
        VStack(spacing: 30) {
            Text("How to Delete Movies")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(Color.red)
                .padding(.bottom)
                .padding(.top, 50)
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
