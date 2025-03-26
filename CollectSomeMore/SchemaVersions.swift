//
//  SchemaVersions.swift
//  CollectSomeMore
//
//  Created by Adam Jolicoeur on 3/26/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

//@preconcurrency import SwiftData

//enum VersionedSchema {
//    // MARK: - Version 1
//
//    enum Version1 {
//        static let versionIdentifier = Schema.Version(1, 0, 0)
//        static let models: [any PersistentModel.Type] = [CollectionV1.self]
//    }
//
//    @Model
//    final class CollectionV1 {
//        var name: String
//
//        init(name: String) {
//            self.name = name
//        }
//    }
//
//    // MARK: - Version 2 (Adding a new optional property)
//
//    enum Version2 {
//        static let versionIdentifier = Schema.Version(2, 0, 0)
//        static let models: [any PersistentModel.Type] = [CollectionV2.self]
//    }
//
//    @Model
//    final class CollectionV2 {
//        var name: String
//        var details: String? // New optional property
//
//        init(name: String, details: String? = nil) {
//            self.name = name
//            self.details = details
//        }
//    }
//}

//extension VersionedSchema {
//    static var currentVersion: Schema.Version {
//        Version2.versionIdentifier
//    }
//
//    static var modelContainer: ModelContainer {
//        let config = ModelConfiguration(schema: Schema([CollectionV1.self, CollectionV2.self]), isStoredInMemoryOnly: false)
//        do {
//            return try ModelContainer(configurations: config)
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }
//}
