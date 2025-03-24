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
        NavigationStack {
            VStack {
                List {
                    Text("Created by \(Text("[Adam Jolicoeur](https://adamjolicoeur.com)"))")
                        .padding(.leading, 20)
                    Text("Games and Things is a collection app to help manage all of the games and other things that you collect. I hope you enjoy it!")
                        .padding(.leading, 20)
                    Text("Version 1.0")
                        .font(.subheadline)
                        .padding(.leading, 20)
                    Section(header: Text("How do I?")) {
                        NavigationLink(destination: HowToView()) {
                            Text("Add or Remove an item")
                                .padding(.leading, 20)
                        }
                    }
                    .font(.title3)
                    .listRowSeparator(.hidden)
                    Section(header: Text("Have a problem?")) {
                        Text("Restart the app to clear any data.")
                            .padding(.leading, 20)
                        Text("Remove the app from your device and reinstall it.")
                            .padding(.leading, 20)
                    }
                    .font(.title3)
                    Section(header: Text("Issue or Questions?")) {
                        Link("Submit a bug report", destination: URL(string: "https://github.com/AdamJ/CollectSomeMore/issues/new")!)
                            .padding(.leading, 20)
                        Text("Try the \(Text("[FAQ](https://github.com/AdamJ/CollectSomeMore/wiki/FAQ)").underline()).")
                            .padding(.leading, 20)
                    }
                    .font(.title3)
                    //            Image("ThreadsBadge")
                    //                .resizable()
                    //                .interpolation(.none)
                    //                .aspectRatio(contentMode: .fit)
                    //                .frame(width: 200, height: 200, alignment: .topLeading)
                    //                .border(.borderPrimary)
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("About")
                .listStyle(SidebarListStyle())
            }
            .background(Gradient(colors: darkBottom))
            .foregroundStyle(.gray09)
        }
    }
}

#Preview {
    AboutView()
        .frame(maxHeight: .infinity)
        .background(Gradient(colors: gradientColors))
}
