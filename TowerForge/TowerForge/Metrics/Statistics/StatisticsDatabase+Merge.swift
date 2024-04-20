//
//  StatisticsDatabase+Merge.swift
//  TowerForge
//
//  Created by Rubesh on 14/4/24.
//

import Foundation

/// This extension adds merging abilities to the StatisticsDatabase.
///
/// Represen
extension StatisticsDatabase: Equatable {
    static func == (lhs: StatisticsDatabase, rhs: StatisticsDatabase) -> Bool {
        guard lhs.statistics.count == rhs.statistics.count else {
            return false
        }

        return lhs.statistics.keys.allSatisfy {
            (lhs.statistics[$0]?.statisticName == rhs.statistics[$0]?.statisticName) &&
            (lhs.statistics[$0]?.permanentValue == rhs.statistics[$0]?.permanentValue) &&
            (lhs.statistics[$0]?.currentValue == rhs.statistics[$0]?.currentValue)
        }
    }

    /// Compares two StatisticsDatabase instances and outputs a merged version
    ///
    /// Merge Invariants:
    /// - 1. The final database must have all keys in both databases.
    /// - 2. Retain the value that has the greater magnitude in the final database for duplicate keys
    /// - 3. There should not be any keys in the final database that are not within the first or second database.
    /// - 4. For duplicate keys that have the same value, either value can be retained in the final database.
    static func merge(this: StatisticsDatabase?, that: StatisticsDatabase?) -> StatisticsDatabase? {
        Logger.log("SDB: Merge function entered.", self)
        guard this != nil || that != nil else {
            Logger.log("SDB: Both nil, returning nil", self)
            return nil
        }

        var lhs = StatisticsDatabase()
        var rhs = StatisticsDatabase()

        if let this = this {
            lhs = this
        }

        if let that = that {
            rhs = that
        }

        let mergedStats = StatisticsDatabase()

        // Merge lhs statistics
        for (key, lhsStat) in lhs.statistics {
            mergedStats.statistics[key] = lhsStat
        }

        // Merge rhs statistics and resolve conflicts
        for (key, rhsStat) in rhs.statistics {
            if let lhsStat = mergedStats.statistics[key] {

                // If lhs has the key, compare and choose the one with the greater magnitude.
                if lhsStat.permanentValue < rhsStat.permanentValue || lhsStat.currentValue < rhsStat.currentValue {

                    mergedStats.statistics[key]?.permanentValue = Double.maximumMagnitude(lhsStat.permanentValue,
                                                                                          rhsStat.permanentValue)

                    mergedStats.statistics[key]?.currentValue = Double.maximumMagnitude(lhsStat.currentValue,
                                                                                        rhsStat.currentValue)

                    mergedStats.statistics[key]?.currentValue = Double.maximumMagnitude(lhsStat.maximumCurrentValue,
                                                                                        rhsStat.maximumCurrentValue)
                }
                // If they are equal, lhsStat is already set, so do nothing.
            } else {

                // If lhs does not have the key, simply add the rhs stat.
                mergedStats.statistics[key] = rhsStat
            }
        }

        Logger.log("SDB: Merged stats contain \(mergedStats.toString())")
        return mergedStats
    }
}
