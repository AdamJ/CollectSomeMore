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
        VStack(spacing: Constants.SpacerSmall) {
            Text("How to Delete List Items")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top, Constants.SpacerSmall)
                .padding(.bottom, Constants.SpacerSmall)
            List {
                Section(header: Text("Method 1")) {
                    VStack(alignment: .leading) {
                        Text("1. Swipe left on a movie in your library")
                            .listRowSeparator(Visibility.visible, edges: .bottom)
                        Text("2. Tap 'Delete'")
                            .listRowSeparator(Visibility.visible, edges: .bottom)
                    }
                }
                .padding(0)
                Section(header: Text("Method 2")) {
                    VStack(alignment: .leading) {
                        Text("1. Tap 'Edit' in the top left corner of the screen")
                            .listRowSeparator(Visibility.visible, edges: .bottom)
                        Text("2. Tap (-) next to the desired movie or game")
                            .listRowSeparator(Visibility.visible, edges: .bottom)
                        Text("3. Tap 'Delete' on the desired movie or game")
                            .listRowSeparator(Visibility.visible, edges: .bottom)
                        Text("4. Tap 'Done' in the top left corner of the screen")
                            .listRowSeparator(Visibility.visible, edges: .bottom)
                    }
                }
                .padding(0)
                Section(header: Text("Method 3")) {
                    VStack(alignment: .leading) {
                        Text("1. Open an item from the list")
                            .listRowSeparator(Visibility.visible, edges: .bottom)
                        Text("2. Tap 'Delete' in the top right corner of the screen")
                            .listRowSeparator(Visibility.visible, edges: .bottom)
                        Text("3. Confirm your deletion by tapping 'Delete' in the pop-up")
                            .listRowSeparator(Visibility.visible, edges: .bottom)
                    }
                }
                .padding(0)
            }
            .scrollContentBackground(.hidden)
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
