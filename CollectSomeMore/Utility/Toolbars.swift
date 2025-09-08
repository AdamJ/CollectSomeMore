//
//  Toolbars.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 6/4/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct CustomToolbar: View {
    @Environment(\.dismiss) private var dismiss
    var title: String
    var leadingButton: (() -> Void)? = nil // Optional action for leading button
    var leadingButtonImage: String? = nil // Optional system image name for leading button
    var trailingButton: (() -> Void)? = nil // Optional action for trailing button
    var trailingButtonImage: String? = nil // Optional system image name for trailing button
    var trailingButtonText: String? = nil // Optional text for trailing button

    var body: some View {
        HStack {
            // Leading Button
            if let leadingAction = leadingButton, let imageName = leadingButtonImage {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: imageName)
                            .foregroundColor(Colors.white)
                        Text("Back")
                            .foregroundColor(Colors.white)
                    }
                }
            } else {
                // Spacer to balance the title if no leading button
                Spacer()
            }

            Spacer() // Pushes title to center, and buttons to edges

            // Title
            Text(title)
                .titleStyle()
                .foregroundColor(.onSurface) // Your desired text color

            Spacer() // Pushes title to center, and buttons to edges

            // Trailing Button
            if let trailingAction = trailingButton {
                Button(action: trailingAction) {
                    if let imageName = trailingButtonImage {
                        Image(systemName: imageName)
                            .foregroundColor(Colors.white)
                    } else if let buttonText = trailingButtonText {
                        Text(buttonText)
                            .foregroundColor(Colors.white)
                    } else {
                        // Fallback if neither image nor text is provided
                        Image(systemName: "ellipsis.circle") // Default icon
                            .foregroundColor(Colors.white)
                    }
                }
            } else {
                // Spacer to balance the title if no trailing button
                Spacer()
            }
        }
        .padding() // Add padding around the content of the toolbar
        .background(Colors.surfaceLevel)
        .frame(maxWidth: .infinity)
        // You might need to add a top edge ignore safe area depending on your layout
        // .ignoresSafeArea(.all, edges: .top) // Use with caution, can hide status bar
    }
}
