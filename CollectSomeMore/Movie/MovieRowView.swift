//
//  MovieRowView.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 10/8/24.
//  Style rows for displaying movie information
//    in order to keep the main MovieList file cleaner
//

import SwiftUI
import SwiftData

struct LocationIconView: View {
    let locations: String // Assuming location is a String
    let iconNames: [String: String] = [
        "Cabinet": "tag",
        "iTunes": "tv.and.mediabox",
        "Network": "externaldrive.badge.wifi",
        "Other": "questionmark.circle.dashed",
        "None": ""
    ]

    var body: some View {
        if let iconName = iconNames[locations] {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .padding(4)
                .frame(width: 28, height: 28)
                .foregroundStyle(.primaryApp)
        } else {
            Image(systemName: "")
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
        }
    }
}

struct MovieRowView: View {
    @Bindable var collection: Collection
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    let collectionLocation: [LocationIconView] = [
        LocationIconView(locations: "Cabinet"),
        LocationIconView(locations: "iTunes"),
        LocationIconView(locations: "Network"),
        LocationIconView(locations: "Other"),
        LocationIconView(locations: "None")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 2) {
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 1) {
                        Text(collection.title)
                            .foregroundColor(.text)
                            .font(.title3)
                            .fontWeight(.semibold)
                        HStack {
                            let colors: [String: Color] = ["G": .backgroundGreen, "PG": .backgroundBlue, "PG-13": .backgroundOrange, "R": .backgroundRed, "NR": .gray02, "Unrated": .backgroundYellow]
                            Text(collection.ratings)
                                .font(.caption2)
                                .fontWeight(.bold)
                                .padding(4)
                                .background(colors[collection.ratings, default: .gray01])
                                .foregroundStyle(.gray09)
                            if UserInterfaceSizeClass.compact != horizontalSizeClass {
                                LocationIconView(locations: collection.locations)
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}
