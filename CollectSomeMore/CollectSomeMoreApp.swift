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
    private(set) static var shared: GameData!

    let modelContainer: ModelContainer
    let context: ModelContext
    
    init(container: ModelContainer) {
        self.modelContainer = container
        self.context = container.mainContext
        #if DEBUG
        insertSampleData(modelContext: context) // Only insert sample data when in DEBUG mode
        #endif
        GameData.shared = self
    }

    private func insertSampleData(modelContext: ModelContext) {
        // Check and insert GameCollection data
        if (try? modelContext.fetchCount(FetchDescriptor<GameCollection>())) == 0 {
            for collection in GameCollection.sampleGameCollectionData {
                modelContext.insert(collection)
            }
            do {
                try modelContext.save()
                print("Sample game data inserted successfully.")
            } catch {
                print("Sample game data context failed to save: \(error)")
            }
        } else {
            print("Sample game data already exists. No need to insert.")
        }

        // Check and insert MovieCollection data
        if (try? modelContext.fetchCount(FetchDescriptor<MovieCollection>())) == 0 {
            for collection in MovieCollection.sampleMovieCollectionData {
                modelContext.insert(collection)
            }
            do {
                try modelContext.save()
                print("Sample movie data inserted successfully.")
            } catch {
                print("Sample movie data context failed to save: \(error)")
            }
        } else {
            print("Sample movie data already exists. No need to insert.")
        }

        // Check and insert ComicCollection data
        if (try? modelContext.fetchCount(FetchDescriptor<ComicCollection>())) == 0 {
            for collection in ComicCollection.sampleComicCollectionData {
                modelContext.insert(collection)
            }
            do {
                try modelContext.save()
                print("Sample comic data inserted successfully.")
            } catch {
                print("Sample comic data context failed to save: \(error)")
            }
        } else {
            print("Sample comic data already exists. No need to insert.")
        }
    }

    var collection: GameCollection {
        GameCollection.sampleGameCollectionData[0]
    }
}

@main
struct GamesAndThings: App {
    let gameData: GameData

    init() {
        let schema = Schema([
            MovieCollection.self,
            GameCollection.self,
            ComicCollection.self // Add ComicCollection to schema
        ])

        let modelConfiguration = ModelConfiguration(
            schema: schema
            // cloudKitDatabase: .private("iCloud.com.adamjolicoeur.gamesandthings") removed for local-only storage
        )

        do {
            let container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            gameData = GameData(container: container)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.modelContext, gameData.context)
        }
    }
}

#if DEBUG
// Function to delete SwiftData storage (Keep this for debugging/resetting if needed)
func deleteAllData(modelContext: ModelContext) {
    try? modelContext.delete(model: GameCollection.self)
    try? modelContext.delete(model: MovieCollection.self)
    try? modelContext.delete(model: ComicCollection.self) // Add ComicCollection deletion
    try? modelContext.save()
}
#endif
