//
//  Metadata.swift
//  TowerForge
//
//  Created by Rubesh on 14/4/24.
//

import Foundation

/// The metadata class is used to encapsulate 
///
/// - Information about device and the current user for use with Remote Storage
/// - Meta-information about files stored locally, possibly for use with conflict resolution.
class Metadata: Codable, Comparable, Equatable {
    let uniqueIdentifier: String
    var lastUpdated: Date

    init(lastUpdated: Date, uniqueIdentifier: String) {
        self.lastUpdated = lastUpdated
        self.uniqueIdentifier = uniqueIdentifier
    }

    required init() {
        self.lastUpdated = Date()
        self.uniqueIdentifier = UUID().uuidString
    }

    static func == (lhs: Metadata, rhs: Metadata) -> Bool {
        lhs.lastUpdated == rhs.lastUpdated && lhs.uniqueIdentifier == rhs.uniqueIdentifier
    }

    static func < (lhs: Metadata, rhs: Metadata) -> Bool {
        lhs.lastUpdated < rhs.lastUpdated
    }

    static func > (lhs: Metadata, rhs: Metadata) -> Bool {
        lhs.lastUpdated > rhs.lastUpdated
    }
}
