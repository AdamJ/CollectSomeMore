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

struct MovieRowView: View {
    @Bindable var collection: Collection

    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 4) {
                HStack(spacing: 0) {
                  VStack(spacing: 0) {
                      Image("Animoji")
                          .resizable()
                          .aspectRatio(contentMode: .fit)
                          .frame(width: 36, height: 36)
                          .border(.borderPrimary)
                          .clipShape(.circle)
                  }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
                .frame(width: 44, height: 44);
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(collection.title)
                            .foregroundColor(.text)
                            .font(.headline)
                        HStack(spacing: 0) {
                            Text(collection.genre)
                                .padding(.horizontal)
                                .foregroundStyle(.tertiaryText)
                        }
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    }
                }
            }
        }
    }
}

