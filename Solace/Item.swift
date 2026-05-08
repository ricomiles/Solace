//
//  Item.swift
//  Solace
//
//  Created by Rico Miles Quiblat on 5/8/26.
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
