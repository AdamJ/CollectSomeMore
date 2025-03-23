//
//  About.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/21/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    
    var body: some View {
        VStack {
            Text("About")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
            Text("Games and Things is a collection app to help manage all of the games and other things that you collect. I hope you enjoy it!")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()
            Text("Version 1.0")
                .font(.title3)
                .padding()
            Spacer()
            Text("Created by Adam Jolicoeur")
                .font(.title3)
            Link("www.adamjolicoeur.com", destination: URL(string: "https://adamjolicoeur.com")!)
            Spacer()
            Text("Question? Try our \(Text("[FAQ](https://github.com/AdamJ/CollectSomeMore/wiki/FAQ)").underline()).")
            Text("Found an issue? \(Text("[Let me know](https://github.com/AdamJ/CollectSomeMore/issues/new)").underline()).")
                .padding(.bottom)
//            Image("ThreadsBadge")
//                .resizable()
//                .interpolation(.none)
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 200, height: 200, alignment: .topLeading)
//                .border(.borderPrimary)
        }
        .padding()
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    AboutView()
        .frame(maxHeight: .infinity)
        .background(Gradient(colors: gradientColors))
}
