//  WhereIsDataStored.swift
//  GamesAndThings FAQ
//
//  Created for documentation update on 2025-09-08.

import SwiftUI

struct WhereIsDataStored: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                Section {
                    Text("This app stores your data locally on your device using Core Data (SwiftData). Your data is not uploaded to any cloud service and is only accessible on your device.")
                } header: {
                    VStack(alignment: .center, spacing: 8) {
                        Text("Local Storage")
                            .padding(.vertical, 4)
                            .padding(.horizontal, 12)
                            .background(Color.blue.opacity(0.2))
                            .foregroundColor(.primary)
                            .bold()
                    }
                    .cornerRadius(4)
                }
                Section {
                    Text("Your collections can be exported in a CSV format for use in other applications.")
                    Text("On either the Games or Movie collection view, tap the three dots in the top right corner of the screen. Select 'Export Data'.")
                    Text("Select whether you want to export your data to a file on your device or share it with a contact.")
                } header: {
                    VStack(alignment: .center, spacing: 8) {
                        Text("Export Data")
                            .padding(.vertical, 4)
                            .padding(.horizontal, 12)
                            .background(Color.blue.opacity(0.2))
                            .foregroundColor(.primary)
                            .bold()
                    }
                    .cornerRadius(4)
                }
                Section {
                    Text("If you back up your device using iCloud or your computer, your app data will be included in the backup and restored if you restore your device. The app developer does not have access to your data; it is managed by you and Apple’s backup system.")
                } header: {
                    VStack(alignment: .center, spacing: 8) {
                        Text("Backup and Restore")
                            .padding(.vertical, 4)
                            .padding(.horizontal, 12)
                            .background(Color.blue.opacity(0.2))
                            .foregroundColor(.primary)
                            .bold()
                    }
                    .cornerRadius(4)
                }
            }
        }
    }
}

#Preview("Data Storage") {
    WhereIsDataStored()
        .navigationTitle("Data Storage")
}
