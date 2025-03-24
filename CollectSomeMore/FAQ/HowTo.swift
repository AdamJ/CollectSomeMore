//
//  HowTo.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/24/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct HowToView: View {
    var body: some View {
        TabView {
            HowToAdd()
            HowToDelete()
        }
        .background(Gradient(colors: darkBottom))
        .tabViewStyle(.page)
    }
}


#Preview {
    HowToView()
}
