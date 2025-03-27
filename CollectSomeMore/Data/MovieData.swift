//
//  Data.swift
//  CollectSomeMore
//
//  Created by Adam Jolicoeur on 6/7/24.
//

import Foundation
import SwiftData

@MainActor
class MovieData {
    static let shared = MovieData()
    
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    private init() {
        let schema = Schema([
            MovieCollection.self,
            GameCollection.self,
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
        let existingCollections = try? modelContext.fetch(FetchDescriptor<MovieCollection>())
        
        if let existingCollections = existingCollections, existingCollections.isEmpty {
            // Insert sample data only if the database is empty
            for collection in MovieCollection.sampleCollectionData {
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

    var collection: MovieCollection {
        MovieCollection.sampleCollectionData[0]
    }
}
