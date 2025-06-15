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
                    Text("This app utilizes CloudKit to store data.")
                    Text("[Learn more about CloudKit on the Apple Developer site.](https://developer.apple.com/icloud/cloudkit/)")
                } header: {
                    VStack(alignment: .center, spacing: Sizing.SpacerSmall) {
                        Text("CloudKit Storage")
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
                    Text("Select whether you want to export your data to a file on your device, to iCloud, or share it with a contact.")
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

                Section {
                    Text("Should you not want to sync the app's data to iCloud (i.e. backup), you can disable this feature in iCloud settings.")
                    Text("Follow the steps below to turn off syncing.")
                    Label("Open 'Settings'", systemImage: "1.square")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Label("Go into your iCloud account", systemImage: "2.square")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Label("Tap 'iCloud'", systemImage: "3.square")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Label("Tap 'See All' in the 'Saved to iCloud' section", systemImage: "4.square")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Label("Scroll down until you see 'CollectSomeMore' and uncheck the box next to the app's name", systemImage: "5.square")
                        .frame(maxWidth: .infinity, alignment: .leading)
                } header: {
                    VStack(alignment: .center, spacing: Sizing.SpacerSmall) {
                        Text("Don't Want To Sync With iCloud?")
                            .padding(.vertical, Sizing.SpacerXSmall)
                            .padding(.horizontal, Sizing.SpacerMedium)
                            .background(Colors.primaryMaterial)
                            .foregroundColor(Colors.inverseOnSurface)
                            .bodyBoldStyle()
                    }
                    .cornerRadius(Sizing.SpacerXSmall)
                }
            }
            .padding(.top, 8)
            .scrollContentBackground(.hidden)
            .background(Colors.surfaceLevel)
            .navigationTitle("How to add items")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Colors.secondaryContainer, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark)
        }
        .background(Colors.primaryMaterial)
    }
}

#Preview("Data Storage") {
    WhereIsDataStored()
        .navigationTitle("Data Storage")
        .background(Gradient(colors: transparentGradientInverse))
        .frame(maxHeight: .infinity)
}
