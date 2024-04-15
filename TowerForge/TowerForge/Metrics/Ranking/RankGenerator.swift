//
//  RankGenerator.swift
//  TowerForge
//
//  Created by Rubesh on 16/4/24.
//

import Foundation

/// RankGenerator is a Utility class used to derive ranks from Statistics
class RankGenerator {

    /// Adds the rank value of all contained statistics
    static var expFormula: ((StatisticsDatabase) -> Double) = {
        $0.statistics.values.map { $0.rankValue }.reduce(into: .zero) { $0 += $1 }
    }
    
    static func getTotalExp(from stats: StatisticsDatabase) -> Double {
        Self.expFormula(stats)
    }
    
    static func rank(forValue value: Double) -> Rank? {
        return Rank.allCases.first { $0.valueRange.contains(Int(value)) }
    }
}