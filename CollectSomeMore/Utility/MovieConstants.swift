//
//  MovieConstants.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 4/18/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct LocationIconView: View {
    let locations: String
    let iconNames: [String: String] = [
        "Cabinet": "tag",
        "iTunes": "tv.and.mediabox",
        "Network": "externaldrive.badge.wifi",
        "Other": "questionmark.circle.dashed",
        "None": ""
    ]

    var body: some View {
        Image(systemName: iconNames[locations, default: "questionmark.circle"]) // Use default icon
            .resizable()
            .scaledToFit()
            .padding(4)
            .frame(width: 28, height: 28)
            .foregroundStyle(.text)
    }
}
