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
        VStack(spacing: Constants.SpacerSmall) {
            Text("How to Add List Items")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top, Constants.SpacerSmall)
                .padding(.bottom, Constants.SpacerSmall)
            List {
                Section(header: Text("Add an item")) {}
                Text("1. Tap the plus (+) button in the top right corner of the screen.")
                    .listRowSeparator(Visibility.visible, edges: .bottom)
                Text("2. Enter the title of the movie or game")
                    .listRowSeparator(Visibility.visible, edges: .bottom)
                Text("3. Include any details using the optional fields")
                    .listRowSeparator(Visibility.visible, edges: .bottom)
                Text("4. Tap 'Save' to add the movie or game to your library")
                    .listRowSeparator(Visibility.visible, edges: .bottom)
            }
            .scrollContentBackground(.hidden)
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
