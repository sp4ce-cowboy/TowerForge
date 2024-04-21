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

        let mergedStats = StatisticsFactory.getDefaultStatisticsDatabase()

        // Merge lhs statistics
        for (key, lhsStat) in lhs.statistics {
            mergedStats.statistics[key] = lhsStat
        }

        for (key, rhsStat) in rhs.statistics {
            if let lhsStat = mergedStats.statistics[key] {
                mergedStats.statistics[key] = lhsStat.merge(with: rhsStat)
                Logger.log("MERGE-LOOP: Statistic \(key) updated to " +
                           "\(String(describing: mergedStats.statistics[key]))", self)
            } else {
                mergedStats.statistics[key] = rhsStat
                Logger.log("MERGE-LOOP: Statistic \(key) created with " +
                           "\(String(describing: mergedStats.statistics[key]))", self)
            }
        }

        Logger.log("SDB: Merged stats contain \(mergedStats.toString())", self)
        return mergedStats
    }
}
