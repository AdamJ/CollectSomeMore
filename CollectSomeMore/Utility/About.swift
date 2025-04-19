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
                            .frame(width: 72, height: 72)
                        VStack {
                            Text("Created by \(Text("[Adam Jolicoeur](https://adamjolicoeur.com)"))")
                            HStack {
                                Image("github")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                .padding(.horizontal, Sizing.SpacerSmall)
                                Image("threads")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                .padding(.horizontal, Sizing.SpacerSmall)
                                Image("bluesky")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                            }
                        }
                    }
                    Label("Games and Things is a collection app to help manage all of the games and other things that you collect. I hope you enjoy it!", systemImage: "info.circle")
                    Link(destination: URL(string: "https://github.com/AdamJ/CollectSomeMore/releases")!) {
                        Label("Version \(getVersionNumber())", systemImage: "number")
                    }
                    
                    Section(header: Text("FAQ")) {
                        NavigationLink(destination: HowToAdd()) {
                            Text("How do I add items?")
                        }
                        NavigationLink(destination: HowToDelete()) {
                            Text("How do I remove items?")
                        }
                        NavigationLink(destination: WhereIsDataStored()) {
                            Text("Where is my data stored?")
                        }
                    }
                    .backgroundStyle(.accent)
                    .listRowSeparator(.hidden)
                    
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
                    //            Image("ThreadsBadge")
                    //                .resizable()
                    //                .interpolation(.none)
                    //                .aspectRatio(contentMode: .fit)
                    //                .frame(width: 200, height: 200, alignment: .topLeading)
                    //                .border(.borderPrimary)
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("About")
                .navigationBarTitleDisplayMode(.inline)
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
