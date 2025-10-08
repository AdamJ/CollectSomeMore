//
//  ComicRowView.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 9/8/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct ComicRowView: View {
    let comic: ComicCollection
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(comic.comicTitle ?? "Untitled")
                    .font(.headline)
                Text(comic.series ?? "Unknown Series")
                    .font(.subheadline)
                if let issue = comic.issueNumber, !issue.isEmpty {
                    Text("Issue #\(issue)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ComicRowView(comic: ComicCollection(comicTitle: "Sample Comic", series: "Sample Series", issueNumber: "1"))
}
