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
        VStack(spacing: 0) {
            Text("How to Delete List Items")
                .titleStyle()
            List {
                Section {
                    Label("Swipe left on a movie in your library", systemImage: "1.square")
                        
                    Label("Tap 'Delete'", systemImage: "2.square")
                } header: {
                    VStack(alignment: .center, spacing: Sizing.SpacerSmall) {
                        Text("Method 1")
                            .padding(.vertical, Sizing.SpacerXSmall)
                            .padding(.horizontal, Sizing.SpacerMedium)
                            .background(Colors.primaryMaterial)
                            .foregroundColor(Colors.inverseOnSurface)
                            .bodyBoldStyle()
                    }
                    .cornerRadius(Sizing.SpacerXSmall)
                }
                
                Section {
                    Label("Tap 'Edit' in the top left corner of the screen", systemImage: "1.square")
                    Label("Tap (-) next to the desired movie or game", systemImage: "2.square")
                    Label("Tap 'Delete' on the desired movie or game", systemImage: "3.square")
                    Label("Tap 'Done' in the top left corner of the screen", systemImage: "4.square")
                } header: {
                    VStack(alignment: .center, spacing: Sizing.SpacerSmall) {
                        Text("Method 2")
                            .padding(.vertical, Sizing.SpacerXSmall)
                            .padding(.horizontal, Sizing.SpacerMedium)
                            .background(Colors.primaryMaterial)
                            .foregroundColor(Colors.inverseOnSurface)
                            .bodyBoldStyle()
                    }
                    .cornerRadius(Sizing.SpacerXSmall)
                }
                Section {
                    Label("1. Open an item from the list", systemImage: "1.square")
                    Label("2. Tap 'Delete' in the top right corner of the screen", systemImage: "2.square")
                    Label("3. Confirm your deletion by tapping 'Delete' in the pop-up", systemImage: "3.square")
                } header: {
                    VStack(alignment: .center, spacing: Sizing.SpacerSmall) {
                        Text("Method 3")
                            .padding(.vertical, Sizing.SpacerXSmall)
                            .padding(.horizontal, Sizing.SpacerMedium)
                            .background(Colors.primaryMaterial)
                            .foregroundColor(Colors.inverseOnSurface)
                            .bodyBoldStyle()
                    }
                    .cornerRadius(Sizing.SpacerXSmall)
                }
            }
            .scrollContentBackground(.hidden)
            Spacer()
        }
        .background(Colors.surfaceLevel) // list
    }
}

#Preview("Delete View") {
    HowToDelete()
        .navigationTitle("How To Delete")
        .background(Gradient(colors: transparentGradientInverse))
        .frame(maxHeight: .infinity)
}
