//
//  WhereIsDataStored.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/31/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct WhereIsDataStored: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                Section {
                    Text("This app stores your data locally on your device using Core Data (SwiftData). Your data is not uploaded to any cloud service and is only accessible on your device.")
                } header: {
                    VStack(alignment: .center, spacing: Sizing.SpacerSmall) {
                        Text("Local Storage")
                            .padding(.vertical, Sizing.SpacerXSmall)
                            .padding(.horizontal, Sizing.SpacerMedium)
                            .background(Colors.primaryMaterial)
                            .foregroundColor(Colors.inverseOnSurface)
                            .bodyBoldStyle()
                    }
                    .cornerRadius(Sizing.SpacerXSmall)
                }
                Section {
                    Text("Your collections can be exported in a CSV format for use in other applications.")
                    Text("On either the Games or Movie collection view, tap the three dots in the top right corner of the screen. Select \"Export Data\".")
                    Text("Select whether you want to export your data to a file on your device or share it with a contact.")
                } header: {
                    VStack(alignment: .center, spacing: Sizing.SpacerSmall) {
                        Text("Export Data")
                            .padding(.vertical, Sizing.SpacerXSmall)
                            .padding(.horizontal, Sizing.SpacerMedium)
                            .background(Colors.primaryMaterial)
                            .foregroundColor(Colors.inverseOnSurface)
                            .bodyBoldStyle()
                    }
                    .cornerRadius(Sizing.SpacerXSmall)
                }
            }
        }
    }
}

#Preview("Data Storage") {
    WhereIsDataStored()
        .navigationTitle("Data Storage")
        .background(Gradient(colors: transparentGradientInverse))
        .frame(maxHeight: .infinity)
}
