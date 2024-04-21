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
class Metadata: StorageDatabase, Comparable, Equatable {

    static var currentPlayerId: String { Constants.CURRENT_PLAYER_ID }
    static var currentDeviceId: String { Constants.CURRENT_DEVICE_ID }

    var deviceIdentifier: String
    var uniqueIdentifier: String
    var lastUpdated: Date

    init(lastUpdated: Date = .now,
         uniqueIdentifier: String = Metadata.currentPlayerId,
         deviceIdentifer: String = Metadata.currentDeviceId) {
        self.lastUpdated = lastUpdated
        self.uniqueIdentifier = uniqueIdentifier
        self.deviceIdentifier = deviceIdentifer
    }

    init() {
        self.lastUpdated = .now
        let id = UUID().uuidString
        self.uniqueIdentifier = id
        self.deviceIdentifier = id
    }

    func updateTimeToNow() {
        lastUpdated = .now
        Logger.log("Metadata time updated to \(self.lastUpdated.ISO8601Format())", self)
    }

    func updateIdentifierToCurrentID() {
        uniqueIdentifier = Self.currentPlayerId
        Logger.log("Metadata id updated to currentPlayer \(self.uniqueIdentifier)", self)
    }

    func resetIdentifier() {
        uniqueIdentifier = Self.currentDeviceId
        Logger.log("Metadata id updated to currentDevice \(self.uniqueIdentifier)", self)
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

    static func merge(this: Metadata?, that: Metadata?) -> Self? {
        guard let lhs = this, let rhs = that else {
            return nil
        }

        guard let latest = Metadata.latest(lhs: lhs, rhs: rhs) as? Self else {
            return nil
        }

        return latest
    }
}
