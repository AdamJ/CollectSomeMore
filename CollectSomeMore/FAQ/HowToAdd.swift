//
//  HowToAdd.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/24/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct HowToAdd: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("How to Add Movies")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(Color.green)
                .padding(.bottom)
                .padding(.top, 50)
            Spacer()
        }
        .padding()
    }
}

#Preview("How To Add") {
    HowToAdd()
        .navigationTitle("How To")
        .background(Gradient(colors: transparentGradientInverse))
        .frame(maxHeight: .infinity)
}
