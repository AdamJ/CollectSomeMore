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
            
            insertCollectionData()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    func insertCollectionData() {
        for collection in Collection.sampleData {
            context.insert(collection)
        }
        do {
            try context.save()
        } catch {
            print("Sample data context failed to save.")
        }
    }
    
    var collection: Collection {
        Collection.sampleData[0]
    }
}
