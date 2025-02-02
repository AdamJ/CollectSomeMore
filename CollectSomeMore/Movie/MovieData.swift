//
//  Data.swift
//  CollectSomeMore
//
//  Created by Adam Jolicoeur on 6/7/24.
//

import Foundation
import SwiftData

@MainActor
class CollectionData {
    static let shared = CollectionData()
    
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    private init() {
        let schema = Schema([
            Collection.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            insertCollectionData(modelContext: ModelContext.init(modelContainer))
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    func insertCollectionData(modelContext: ModelContext) {
        // Check if any data already exists
        let existingCollections = try? modelContext.fetch(FetchDescriptor<Collection>())
        
        if let existingCollections = existingCollections, existingCollections.isEmpty {
            // Insert sample data only if the database is empty
            for collection in Collection.sampleData {
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

    var collection: Collection {
        Collection.sampleData[0]
    }
}
