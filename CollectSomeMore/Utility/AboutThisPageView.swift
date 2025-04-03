//
//  AboutThisPageView.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 4/2/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct AboutThisPageView: View {
    
    struct Item: Identifiable {
        let id = UUID()
        let name: String
        let description: String
    }

    class ItemViewModel: ObservableObject {
        @Published var items = [
            Item(name: "Apple", description: "A crisp and juicy fruit."),
            Item(name: "Banana", description: "A yellow fruit rich in potassium."),
            Item(name: "Orange", description: "A citrus fruit high in Vitamin C.")
        ]
    }
    
    let item: Item
    @Binding var isPresented: Bool // Binding to the presentation state

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.title)
                    .padding(.bottom)
                Text(item.description)
                    .font(.body)
                Spacer()
            }
            .padding()
            .navigationTitle("Details")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dismiss") {
                        isPresented = false // Set the binding to false to dismiss
                    }
                }
            }
        }
    }
}
