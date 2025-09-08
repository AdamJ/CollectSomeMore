//
//  ArrayExtensions.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 6/6/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
}

extension GameCollection: Hashable {
    public static func == (lhs: GameCollection, rhs: GameCollection) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension MovieCollection: Hashable {
    public static func == (lhs: MovieCollection, rhs: MovieCollection) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

