//
//  FAQ.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 6/9/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct FAQView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    func getVersionNumber() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "Unknown"
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("FAQ")
                    .largeTitleStyle()
            }
        }
        .bodyStyle()
        .navigationBarTitle("FAQ")
        .navigationBarTitleDisplayMode(.inline)
    }
}
