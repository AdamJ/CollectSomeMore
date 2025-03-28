//
//  About.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/21/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    func getVersionNumber() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "Unknown"
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    HStack {
                        Image("Animoji")
                            .resizable()
                            .frame(width: 32, height: 32)
                        Text("Created by \(Text("[Adam Jolicoeur](https://adamjolicoeur.com)"))")
                    }
                        .padding(.leading, Constants.SpacerMedium)
                    HStack {
                        Image(systemName: "questionmark.app")
                        Text("Games and Things is a collection app to help manage all of the games and other things that you collect. I hope you enjoy it!")
                    }
                        .padding(.leading, Constants.SpacerMedium)
                    Link(destination: URL(string: "https://github.com/AdamJ/CollectSomeMore/releases")!) {
                        HStack {
                            Image(systemName: "ellipsis.curlybraces")
                                .font(.title3)
                            Text("Version \(getVersionNumber())")
                        }
                    }
                    .padding(.leading, Constants.SpacerMedium)
                    Section(header: Text("How do I?")) {
                        NavigationLink(destination: HowToView()) {
                            Text("Add or Delete an item")
                                .padding(.leading, Constants.SpacerMedium)
                        }
                    }
                    .font(.title3)
                    .listRowSeparator(.hidden)
                    Section(header: Text("Have a problem?")) {
                        Text("Restart the app to clear any data.")
                            .padding(.leading, Constants.SpacerMedium)
                        Text("Remove the app from your device and reinstall it.")
                            .padding(.leading, Constants.SpacerMedium)
                    }
                    .font(.title3)
                    Section(header: Text("Issue or Questions?")) {
                        Link(destination: URL(string: "https://github.com/AdamJ/CollectSomeMore/issues/new")!) {
                            HStack {
                                Image(systemName: "tray.and.arrow.up")
                                    .font(.title3)
                                Text("Submit a bug report")
                            }
                        }
                        Link(destination: URL(string: "https://github.com/AdamJ/CollectSomeMore/wiki/FAQ")!) {
                            HStack {
                                Image(systemName: "link.circle")
                                    .font(.title3)
                                Text("Read the FAQ")
                            }
                        }
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
