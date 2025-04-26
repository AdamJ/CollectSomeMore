//
//  SettingsView.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 4/23/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: Sizing.SpacerMedium) {
                List {
                    Text("Add an item")
                        .fontWeight(.semibold)
                }
                .listRowBackground(Colors.surfaceLevel)
                .background(Colors.surfaceLevel) // list background
                .scrollContentBackground(.hidden) // allows custom background to show through
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
            }
            .padding()
            .background(Colors.surfaceLevel)
        }
    }
}

#Preview("Settings View") {
    SettingsView()
}
