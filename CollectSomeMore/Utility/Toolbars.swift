//
//  Toolbars.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 6/4/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

//struct ListToolbar: ToolbarContent {
//    var body: some ToolbarContent {
//        ToolbarItemGroup(placement: .primaryAction) {
//            Button(action: addCollection) {
//                Label("Add Game", systemImage: "plus.app")
//                    .labelStyle(.iconOnly)
//            }
//        }
//        ToolbarItemGroup(placement: .secondaryAction) {
//            Button("Adding to a collection", systemImage: "questionmark.circle") {
//                showingAddSheet = true
//            }
//            .sheet(isPresented: $showingAddSheet) {
//                HowToAdd()
//            }
//            Button("Export", systemImage: "square.and.arrow.up") {
//                showingExportSheet = true
//            }
//            .sheet(isPresented: $showingExportSheet) {
//                if let fileURL = createGameCSVFile() {
//                    ShareSheet(activityItems: [fileURL])
//                }
//            }
//            .alert("Export Error", isPresented: $showingAlert) {
//                Button("OK", role: .cancel) { }
//            } message: {
//                Text(alertMessage)
//            }
//        }
//    }
//}
