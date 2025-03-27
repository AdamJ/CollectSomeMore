//
//  Gamesandthings.swift
//  Games and Things - tracking your collections across gaming genres.
//
//  Created by Adam Jolicoeur on 6/7/24.
//

import SwiftUI
import SwiftData

@MainActor
class GameData {
    private(set) static var shared: GameData?
    let modelContainer: ModelContainer

    var context: ModelContext {
        modelContainer.mainContext
    }

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        insertCollectionData(modelContext: context)
        GameData.shared = self // Set the shared instance here
    }

    private init() { // Make the default init unavailable
        fatalError("Use init(modelContainer:) instead")
    }

    func insertCollectionData(modelContext: ModelContext) {
        // Check if any data already exists
        let existingCollections = try? modelContext.fetch(FetchDescriptor<GameCollection>())

        if let existingCollections = existingCollections, existingCollections.isEmpty {
            // Insert sample data only if the database is empty
            for collection in GameCollection.sampleGameCollectionData {
                modelContext.insert(collection)
            }

            do {
                try modelContext.save()
                print("Sample data inserted successfully.")
            } catch {
                print("Sample data context failed to save: \(error)")
            }
        } else {
            print("Sample data already exists. No need to insert.")
        }
    }

    var collection: GameCollection {
        GameCollection.sampleGameCollectionData[0]
    }
}

@main
struct GamesAndThings: App {
    let container: ModelContainer = {
        let schema = Schema([
            MovieCollection.self,
            GameCollection.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        _ = GameData(modelContainer: container) // Initialize GameData and set shared
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.modelContext, container.mainContext)
        }
    }
}
