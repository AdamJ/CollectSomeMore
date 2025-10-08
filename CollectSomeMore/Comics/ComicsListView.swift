//
//  ComicsListView.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 9/8/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI
import SwiftData

struct ComicsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\ComicCollection.enteredDate, order: .reverse)]) var comics: [ComicCollection]
    
    var body: some View {
        NavigationView {
            if comics.isEmpty {
                Text("No comics entered yet.")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                List {
                    ForEach(comics) { comic in
                        NavigationLink(destination: ComicDetailView(comicCollection: comic)) {
                            ComicRowView(comic: comic)
                        }
                    }
                }
            }
        }
        .navigationTitle("Comics")
    }
}

#Preview {
    ComicsListView()
        .modelContainer(for: ComicCollection.self, inMemory: true)
}
