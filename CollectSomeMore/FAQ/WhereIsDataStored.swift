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
        NavigationStack {
            VStack(spacing: Sizing.SpacerSmall) {
                Text("All data is stored locally on your device using SwiftData.")
                Text("[Learn more about SwiftData on the Apple Developer site.](https://developer.apple.com/xcode/swiftdata/)")
                    .padding(.bottom, Sizing.SpacerMedium)
            }
            List {
                
                VStack{
                    Text("CloudKit Sync")
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .padding(.top, Sizing.SpacerMedium)
                        .padding(.bottom, Sizing.SpacerSmall)
                }
                Text("If you have an iCloud account, your data is automatically synced between your device and iCloud. \(Text("[Learn more about CloudKit on the Apple Developer site.](https://developer.apple.com/icloud/cloudkit/)"))")
                Section(header: Text("What if I don't want it to sync with iCloud?")) {
                    Text("Should you not want to sync the app's data to iCloud, you can disable this feature in iCloud settings. Follow the steps below to turn off syncing.")
                    Text("1. Open 'Settings'")
                    Text("2. Go into your iCloud account")
                    Text("3. Tap 'iCloud'")
                    Text("4. Tap 'See All' in the 'Saved to iCloud' section")
                    Text("5. Scroll down until you see 'Games And Things' and uncheck the box next to the app's name")
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Where is my data stored?")
                .navigationBarTitleDisplayMode(.inline)
                .listStyle(SidebarListStyle())
            }
        }
    }
}

#Preview("Where is my data stored?") {
    WhereIsDataStored()
        .navigationTitle("Data Storage")
        .background(Gradient(colors: transparentGradientInverse))
        .frame(maxHeight: .infinity)
}
