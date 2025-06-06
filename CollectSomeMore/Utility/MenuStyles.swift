//
//  MenuStyles.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 6/5/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct FilterMenuStyle : MenuStyle {
    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .padding(.vertical, Sizing.SpacerXSmall)
            .padding(.horizontal, Sizing.SpacerSmall)
            .background(Color.gray05.opacity(0.2))
            .foregroundStyle(Color.white)
            .captionStyle()
            .clipShape(RoundedRectangle(cornerRadius: Sizing.SpacerMedium))
    }
}

extension MenuStyle where Self == FilterMenuStyle {
    static var filter: FilterMenuStyle {
        FilterMenuStyle()
    }
}
