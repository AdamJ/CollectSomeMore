//
//  GameData.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/26/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

//import Foundation
//import SwiftData
//
//@MainActor
//class GameData {
//    static let shared = GameData()
//    
//    let modelContainer: ModelContainer
//    
//    var context: ModelContext {
//        modelContainer.mainContext
//    }
//    
//    private init() {
//        let schema = Schema([
//            GameCollection.self,
//            MovieCollection.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//        
//        do {
//            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
//            
//            insertCollectionData(modelContext: ModelContext.init(modelContainer))
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }
//import Foundation
//import SwiftData
//
//@MainActor
//class GameData {
//    static let shared: GameData // Will be initialized in the App struct
//    let modelContainer: ModelContainer
//
//    var context: ModelContext {
//        modelContainer.mainContext
//    }
//
//    init(modelContainer: ModelContainer) {
//        self.modelContainer = modelContainer
//        insertCollectionData(modelContext: context)
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
