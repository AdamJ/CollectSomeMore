//
//  Gamesandthings.swift
//  Games and Things - tracking your collections across gaming genres.
//
//  Created by Adam Jolicoeur on 6/7/24.
//

import SwiftUI
import SwiftData
import CloudKit

@MainActor
class GameData {
    private(set) static var shared: GameData!

    let modelContainer: ModelContainer
    let context: ModelContext

    init(container: ModelContainer) {
        self.modelContainer = container
        self.context = container.mainContext
        
        #if DEBUG
        insertAllSampleData(into: context)
        #endif
        
        GameData.shared = self
    }
    
    private func insertSampleData<T: PersistentModel>(
            into modelContext: ModelContext,
            sampleData: [T],
            for type: T.Type
        ) {
            do {
                let fetchDescriptor = FetchDescriptor<T>()
                let count = try modelContext.fetchCount(fetchDescriptor)

                if count == 0 {
                    for item in sampleData {
                        modelContext.insert(item)
                    }
                    // Save changes to the persistent store immediately after insertion
                    try modelContext.save()
                    print("✅ Sample data for \(type) inserted successfully.")
                } else {
                    print("ℹ️ Sample data for \(type) already exists. No new insertion needed.")
                }
            } catch {
                print("❌ Failed to insert sample data for \(type): \(error.localizedDescription)")
            }
        }
    private func insertAllSampleData(into modelContext: ModelContext) {
        insertSampleData(into: modelContext, sampleData: GameCollection.sampleGameCollectionData, for: GameCollection.self)
        insertSampleData(into: modelContext, sampleData: MovieCollection.sampleMovieCollectionData, for: MovieCollection.self)
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
            GameCollection.self
        ])

        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            allowsSave: true, // Explicitly include this, as the error indicated it's expected
            // groupContainer: nil, // Only include if you're using App Groups, otherwise omit
            cloudKitDatabase: .private("iCloud.Jolicoeur.CollectSomeMore")
        )

        do {
            let container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            gameData = GameData(container: container)
        } catch {
            fatalError("❌ Could not create ModelContainer: \(error.localizedDescription)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.modelContext, gameData.context)
        }
    }
}

func deleteSwiftDataStore() {
    // Locate the URL for your SwiftData store file.
    // The default name is usually "<YourAppModuleName>.sqlite".
    guard let applicationSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
        print("❌ Could not find Application Support directory.")
        return
    }
    let storeURL = applicationSupportURL.appendingPathComponent("CollectSomeMore.sqlite") // **Verify this exact filename**

    do {
        if FileManager.default.fileExists(atPath: storeURL.path) {
            try FileManager.default.removeItem(at: storeURL)
            print("🗑️ Deleted SwiftData store at \(storeURL.lastPathComponent).")
        } else {
            print("🔍 SwiftData store not found at \(storeURL.lastPathComponent). Nothing to delete.")
        }
    } catch {
        print("❌ Error deleting SwiftData store: \(error.localizedDescription)")
    }
}
