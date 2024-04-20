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
    var uniqueIdentifier: String
    var lastUpdated: Date

    init(lastUpdated: Date = .now,
         uniqueIdentifier: String = Constants.CURRENT_PLAYER_ID) {
        self.lastUpdated = lastUpdated
        self.uniqueIdentifier = uniqueIdentifier
    }

    init() {
        self.lastUpdated = .now
        self.uniqueIdentifier = UUID().uuidString
    }

    func update() {
        Logger.log("Metadata update as at \(Date.now.ISO8601Format())")
        lastUpdated = .now
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

    static func latest(lhs: Metadata, rhs: Metadata) -> Metadata {
        rhs.lastUpdated > lhs.lastUpdated ? rhs : lhs
    }
}
