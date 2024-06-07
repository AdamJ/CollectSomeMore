//
//  Item.swift
//  CollectSomeMore
//
//  Created by Adam Jolicoeur on 6/7/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
