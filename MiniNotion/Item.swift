//
//  Item.swift
//  MiniNotion
//
//  Created by Lidia Galdino on 23/04/26.
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
