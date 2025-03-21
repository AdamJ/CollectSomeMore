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
        "Other": "questionmark.circle.dashed"
    ]

    var body: some View {
        if let iconName = iconNames[locations] {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .padding(4)
                .frame(width: 24, height: 25)
                .foregroundStyle(.primaryApp)
        } else {
            Image(systemName: "questionmark.circle.dashed")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 25)
        }
    }
}

struct MovieRowView: View {
    @Bindable var collection: Collection
    
    let collectionLocation: [LocationIconView] = [
        LocationIconView(locations: "Cabinet"),
        LocationIconView(locations: "iTunes"),
        LocationIconView(locations: "Network")
        ]
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 4) {
//                HStack(spacing: 0) {
//                  Image("MoviePoster")
//                      .resizable()
//                      .aspectRatio(contentMode: .fit)
//                      .frame(width: 36, height: 36)
//                      .border(.borderPrimary)
//                      .clipShape(.circle)
//                      .overlay(Circle().stroke(.gray, lineWidth: 2))
//                }
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(collection.title)
                            .foregroundColor(.text)
                            .font(.title2)
                        HStack {
                            let colors: [String: Color] = ["G": .green, "PG": .green, "PG-13": .orange, "R": .red, "NR": .gray, "Unrated": .tertiaryText]
                            Text(collection.ratings)
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(4)
                                .background(colors[collection.ratings, default: .tertiaryText])
                                .foregroundStyle(.white)
                            LocationIconView(locations: collection.locations)
                        }
                    }
                    Spacer()
                    VStack(spacing: 3) {
                        Text("Info")
                            .font(.subheadline)
                            .foregroundColor(.linkText)
                    }
                }
            }
        }
    }
}
