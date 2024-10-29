//
//  Gamesandthings.swift
//  Games and Things - tracking your collections across gaming genres.
//
//  Created by Adam Jolicoeur on 6/7/24.
//

import SwiftUI
import SwiftData

@main
struct GamesAndThings: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Collection.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
