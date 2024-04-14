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
extension StatisticsDatabase {

    /// Compares two StatisticsDatabase instances and outputs a merged version
    ///
    /// Merge Invariants:
    /// - 1. The final database must have all keys in both databases.
    /// - 2. Retain the value that has the greater magnitude in the final database for duplicate keys
    /// - 3. There should not be any keys in the final database that are not within the first or second database.
    /// - 4. For duplicate keys that have the same value, either value can be retained in the final database.
    static func merge(lhs: StatisticsDatabase, rhs: StatisticsDatabase) -> StatisticsDatabase {
        let mergedStats = StatisticsDatabase()

        // Merge lhs statistics
        for (key, lhsStat) in lhs.statistics {
            mergedStats.statistics[key] = lhsStat
        }

        // Merge rhs statistics and resolve conflicts
        for (key, rhsStat) in rhs.statistics {
            if let lhsStat = mergedStats.statistics[key] {

                // If lhs has the key, compare and choose the one with the greater magnitude.
                if lhsStat.permanentValue < rhsStat.permanentValue {
                    mergedStats.statistics[key] = rhsStat
                }
                // If they are equal, lhsStat is already set, so do nothing.
            } else {

                // If lhs does not have the key, simply add the rhs stat.
                mergedStats.statistics[key] = rhsStat
            }
        }
        
        return mergedStats
    }
}
