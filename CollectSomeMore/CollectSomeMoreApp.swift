////
////  Gamesandthings.swift
////  Games and Things - tracking your collections across gaming genres.
////
////  Created by Adam Jolicoeur on 6/7/24.
////
//
//import SwiftUI
//import SwiftData
//
//@MainActor
//class GameData {
//    private(set) static var shared: GameData?
//    let modelContainer: ModelContainer
//
//    var context: ModelContext {
//        modelContainer.mainContext
//    }
//
//    init(modelContainer: ModelContainer) {
//        self.modelContainer = modelContainer
//        insertCollectionData(modelContext: context)
//        GameData.shared = self // Set the shared instance here
//    }
//
//    private init() { // Make the default init unavailable
//        fatalError("Use init(modelContainer:) instead")
//    }
//
//    func insertCollectionData(modelContext: ModelContext) {
//        // Check if any data already exists
//        let existingCollections = try? modelContext.fetch(FetchDescriptor<GameCollection>())
//
//        if let existingCollections = existingCollections, existingCollections.isEmpty {
//            // Insert sample data only if the database is empty
//            for collection in GameCollection.sampleGameCollectionData {
//                modelContext.insert(collection)
//            }
//
//            do {
//                try modelContext.save()
//                print("Sample data inserted successfully.")
//            } catch {
//                print("Sample data context failed to save: \(error)")
//            }
//        } else {
//            print("Sample data already exists. No need to insert.")
//        }
//    }
//
//    var collection: GameCollection {
//        GameCollection.sampleGameCollectionData[0]
//    }
//}
//
//@main
//struct GamesAndThings: App {
//    init() {
//            deleteSwiftDataStore() // Deletes the old database
//        }
//    let container: ModelContainer = {
//        let schema = Schema([
//            MovieCollection.self,
//            GameCollection.self
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
//    
////    init() {
////        _ = GameData(modelContainer: container) // Initialize GameData and set shared
////    }
//    
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
////                .environment(\.modelContext, container.mainContext)
//                .modelContainer(for: GameCollection.self)
//        }
//    }
//}
//// Function to delete SwiftData storage
//func deleteSwiftDataStore() {
//    let storeURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
//        .appendingPathComponent("MyApp.sqlite") // Change "MyApp" to match your app name
//
//    do {
//        if FileManager.default.fileExists(atPath: storeURL.path) {
//            try FileManager.default.removeItem(at: storeURL)
//            print("Deleted SwiftData store at \(storeURL)")
//        }
//    } catch {
//        print("Error deleting SwiftData store: \(error)")
//    }
//}

import SwiftUI
import SwiftData
import CloudKit

@MainActor
class GameData {
    private(set) static var shared: GameData! // Force unwrap as it will be initialized in App

    let modelContainer: ModelContainer
    let context: ModelContext

    init(container: ModelContainer) {
        self.modelContainer = container
        self.context = container.mainContext
        insertCollectionData(modelContext: context)
        GameData.shared = self
    }

    private func insertCollectionData(modelContext: ModelContext) {
        // Check if any data already exists
        if (try? modelContext.fetchCount(FetchDescriptor<GameCollection>())) == 0 {
            // Insert sample data only if the database is empty
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

        if (try? modelContext.fetchCount(FetchDescriptor<MovieCollection>())) == 0 {
            for collection in MovieCollection.sampleCollectionData {
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

        let containerIdentifier = "iCloud.Jolicoeur.CollectSomeMore" // Replace with your CloudKit Container Identifier

        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
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

// Function to delete SwiftData storage (Keep this for debugging/resetting if needed)
func deleteSwiftDataStore() {
    let storeURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        .appendingPathComponent("MyApp.sqlite") // Ensure this matches your app's store name

    do {
        if FileManager.default.fileExists(atPath: storeURL.path) {
            try FileManager.default.removeItem(at: storeURL)
            print("Deleted SwiftData store at \(storeURL)")
        }
    } catch {
        print("Error deleting SwiftData store: \(error)")
    }
}
