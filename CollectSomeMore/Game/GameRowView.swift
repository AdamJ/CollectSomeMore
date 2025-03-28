//
//  GameRowView.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/26/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI
import SwiftData

struct GameRowView: View {
    @Bindable var gameCollection: GameCollection
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    var body: some View {
        HStack(spacing: Constants.SpacerNone) {
            HStack(spacing: Constants.SpacerNone) {
                VStack(alignment: .leading, spacing: Constants.SpacerNone) {
                    Text(gameCollection.gameTitle)
                        .foregroundColor(.text)
                        .font(.body)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                }
                .padding(.trailing, Constants.SpacerMedium)
                HStack {
                    Text(gameCollection.console)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.top, Constants.SpacerXSmall)
                        .padding(.trailing, Constants.SpacerSmall)
                        .padding(.bottom, Constants.SpacerXSmall)
                        .padding(.leading, Constants.SpacerSmall)
                        .foregroundStyle(.text)
                    if UserInterfaceSizeClass.compact != horizontalSizeClass {
                        LocationIconView(locations: gameCollection.locations)
                            .foregroundStyle(.text)
                    }
                }
            }
        }
    }
}
