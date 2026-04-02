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
    @Query(sort: [SortDescriptor(\ComicCollection.enteredDate, order: .reverse)]) var comics: [ComicCollection]
    @State private var newComic: ComicCollection?
    
    var body: some View {
        Group {
            if comics.isEmpty {
                ContentUnavailableView {
                    Label("No comics entered yet.", systemImage: "book.closed")
                } actions: {
                    Button("Add Comic", action: addComic)
                }
            } else {
                List {
                    ForEach(comics) { comic in
                        NavigationLink {
                            ComicDetailView(comicCollection: comic)
                        } label: {
                            ComicRowView(comic: comic)
                        }
                    }
                }
            }
        }
        .navigationTitle("Comics")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: addComic) {
                    Label("Add Comic", systemImage: "plus")
                }
            }
        }
        .sheet(item: $newComic) { comic in
            NavigationStack {
                ComicDetailView(comicCollection: comic, isNew: true)
            }
        }
    }
    
    private func addComic() {
        newComic = ComicCollection()
    }
}

#Preview {
    ComicsListView()
        .modelContainer(for: ComicCollection.self, inMemory: true)
}
