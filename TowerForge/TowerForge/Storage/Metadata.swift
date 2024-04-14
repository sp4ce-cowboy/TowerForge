//
//  Metadata.swift
//  TowerForge
//
//  Created by Rubesh on 14/4/24.
//

import Foundation

/// The metadata class is used to encapsulate meta-information about files
/// stored locally, possibly for use with conflict resolution.
class Metadata: Codable, Comparable, Equatable {
    let lastUpdated: Date

    init(lastUpdated: Date) {
        self.lastUpdated = lastUpdated
    }

    static func == (lhs: Metadata, rhs: Metadata) -> Bool {
        lhs.lastUpdated == rhs.lastUpdated
    }

    static func < (lhs: Metadata, rhs: Metadata) -> Bool {
        lhs.lastUpdated < rhs.lastUpdated
    }

    static func > (lhs: Metadata, rhs: Metadata) -> Bool {
        lhs.lastUpdated > rhs.lastUpdated
    }
}
