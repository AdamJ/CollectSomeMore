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
            Movie.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            insertMovieData()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    func insertMovieData() {
        for movie in Movie.sampleData {
            context.insert(movie)
        }
        
        do {
            try context.save()
        } catch {
            print("Sample data context failed to save.")
        }
    }
    
    var movie: Movie {
        Movie.sampleData[0]
    }
}
