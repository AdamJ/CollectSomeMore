//
//  Settings.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 5/7/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI
import SwiftData

extension String {
    static var settingsUserNameKey : String { "settings.userName" }
    static var settingsUserAddressKey : String { "settings.userAddress" }
    static var settingsUserAdsEnabledKey : String { "settings.isAdsEnabled" }
    static var adPrivacyTypeKey : String { "settings.adPrivacyType" }
}

struct SettingsView: View {
    @AppStorage(wrappedValue: "", .settingsUserNameKey) // Need the wrappedValue initialiser
    private var userName: String
    
    @AppStorage(.settingsUserAddressKey) // No Need the wrappedValue initialiser
    private var userAddress: String = ""
    
    @AppStorage(.settingsUserAdsEnabledKey)
    private var isAdsEnabled: Bool = false
    
    @AppStorage(.adPrivacyTypeKey)
    private var adPrivacyType: AdPrivacyType = .noTracking
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $userName)
                    TextField("Address", text: $userAddress)
                } header: {
                    Text("Personal Data")
                }
                
                Section {
                    Toggle("Enable Ads", isOn: $isAdsEnabled)
                } header: {
                    Text("Advertising Policy")
                }
                .disabled(userName.isEmpty || userAddress.isEmpty)
                
                if isAdsEnabled {
                    Section {
                        Picker("Select Your Policy", selection: $adPrivacyType) {
                            ForEach(AdPrivacyType.allCases) { trackingPolicy in
                                Text(trackingPolicy.rawValue)
                            }
                        }
                    } header: {
                        Text("Tracking Policy")
                    }
                }

            }
            .bodyStyle()
            .navigationBarTitle("User Settings")
        }
    }
}

enum AdPrivacyType: String, CaseIterable, Identifiable {
    var id: Self {
        return self
    }
    
    case noTracking = "No Tracking"
    case essential = "Only Essential Cookies"
    case full = "Standard Tracking"
}

#Preview("Settings View") {
    SettingsView()
}
