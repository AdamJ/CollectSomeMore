//
//  Badge.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 5/6/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

//struct Badge: View {
//    let label: String
//    let imageName: String
//    
//    func getVersionNumber() -> String {
//        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
//            return version
//        }
//        return "Unknown"
//    }
//    
//    var body: some View {
//        HStack(alignment: .center, spacing: Sizing.SpacerNone) { // Chip
//            BadgeItem(
//                label: "\(getVersionNumber())",
//                imageName: "github"
//            )
//        }
//        .padding(0)
//        .background(Colors.surfaceContainerLow)
//        .cornerRadius(16)
//    }
//}

struct BadgeItem: View {
    let label: String
    let imageName: String
    
    func getVersionNumber() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "Unknown"
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: Sizing.SpacerSmall) { // State Layer
            Image(imageName)
                .resizable()
                .frame(width: 18, height: 18)
            Text(label)
                .background(Colors.surfaceContainerLow)
                .foregroundColor(Colors.onSurface)
                .bodyStyle()
        }
        .padding(.leading, Sizing.SpacerMedium)
        .padding(.trailing, Sizing.SpacerMedium)
        .padding(.vertical, Sizing.SpacerSmall)
        .frame(height: 32)
    }
}
