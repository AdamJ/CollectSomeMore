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
                .foregroundStyle(.text)
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
    
    // When one of these are selected, display corresponding icon from 'let iconNames'
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
                            let borders: [String: Color] = ["G": .borderGreen, "PG": .borderBlue, "PG-13": .borderOrange, "R": .borderError, "NR": .borderPrimary, "Unrated": .borderYellow]
                            Text(collection.ratings)
                                .font(.caption2)
                                .fontWeight(.bold)
                                .padding(4)
                                .background(colors[collection.ratings, default: .gray01])
                                .foregroundStyle(.text)
//                                .border(borders[collection.ratings, default: .gray01], width: 1)
                                .clipShape(.capsule)
                            if UserInterfaceSizeClass.compact != horizontalSizeClass {
                                LocationIconView(locations: collection.locations) // hides the Locations icon when in a compact horizontal side (.i.e. iPhone)
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}
