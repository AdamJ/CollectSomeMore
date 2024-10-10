//
//  HomeView.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 10/8/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        Image("ThreadsBadge")
            .resizable()
            .interpolation(.none)
            .aspectRatio(contentMode: .fit)
            .frame(width: 300, height: 400, alignment: .topLeading)
            .border(.borderPrimary)
    }
}

#Preview {
    HomeView()
}
