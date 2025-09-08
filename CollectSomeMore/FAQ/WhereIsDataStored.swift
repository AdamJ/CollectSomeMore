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
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HeaderView(title: "Where is my data stored?",
                             subtitle: "Understanding data storage and privacy in CollectSomeMore")
                    
                    DataStorageSection()
                    iCloudSyncSection()
                    PrivacySection()
                    DataPortabilitySection()
                    BackupSection()
                }
                .padding()
            }
            .bodyStyle()
            .background(Color.surfaceLevel)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct HeaderView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .titleStyle()
                .foregroundColor(Colors.onSurface)
            
            Text(subtitle)
                .bodyStyle()
                .foregroundColor(Colors.onSurfaceVariant)
        }
    }
}

struct DataStorageSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Local Data Storage")
                .title3Style()
                .foregroundColor(Colors.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Your game and movie collection data is stored locally on your device using SwiftData, Apple's modern data persistence framework.")
                    .bodyStyle()
                
                Text("• Data is stored in a secure, encrypted database on your device")
                    .bodyStyle()
                
                Text("• No personal information is transmitted to third-party servers")
                    .bodyStyle()
                
                Text("• You maintain complete control over your collection data")
                    .bodyStyle()
            }
            .foregroundColor(Colors.onSurface)
        }
        .padding(.vertical, 8)
    }
}

struct iCloudSyncSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("iCloud Synchronization")
                .title3Style()
                .foregroundColor(Colors.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("When enabled, your data is automatically synchronized across all your devices signed into the same iCloud account.")
                    .bodyStyle()
                
                Text("• Data is encrypted in transit and at rest")
                    .bodyStyle()
                
                Text("• Syncing happens automatically in the background")
                    .bodyStyle()
                
                Text("• Data remains private within your Apple ecosystem")
                    .bodyStyle()
                
                Text("• You can disable iCloud sync at any time in Settings")
                    .bodyStyle()
            }
            .foregroundColor(Colors.onSurface)
        }
        .padding(.vertical, 8)
    }
}

struct PrivacySection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Privacy & Security")
                .title3Style()
                .foregroundColor(Colors.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("CollectSomeMore is designed with privacy in mind:")
                    .bodyStyle()
                
                Text("• No analytics or tracking")
                    .bodyStyle()
                
                Text("• No third-party data sharing")
                    .bodyStyle()
                
                Text("• No account creation required")
                    .bodyStyle()
                
                Text("• Data never leaves Apple's ecosystem")
                    .bodyStyle()
            }
            .foregroundColor(Colors.onSurface)
        }
        .padding(.vertical, 8)
    }
}

struct DataPortabilitySection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Data Export")
                .title3Style()
                .foregroundColor(Colors.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("You can export your collection data at any time:")
                    .bodyStyle()
                
                Text("• Export individual collections to CSV format")
                    .bodyStyle()
                
                Text("• Share your collections via email or other apps")
                    .bodyStyle()
                
                Text("• Maintain backups of your data outside the app")
                    .bodyStyle()
            }
            .foregroundColor(Colors.onSurface)
        }
        .padding(.vertical, 8)
    }
}

struct BackupSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Backup & Recovery")
                .title3Style()
                .foregroundColor(Colors.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Your data is automatically included in device backups:")
                    .bodyStyle()
                
                Text("• iCloud device backups include app data")
                    .bodyStyle()
                
                Text("• iTunes/Finder backups preserve your collections")
                    .bodyStyle()
                
                Text("• Restoring from backup recovers your data")
                    .bodyStyle()
                
                Text("• Regular exports provide additional protection")
                    .bodyStyle()
            }
            .foregroundColor(Colors.onSurface)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    WhereIsDataStored()
}
