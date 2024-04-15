//
//  RankingEngine.swift
//  TowerForge
//
//  Created by Rubesh on 16/4/24.
//

import Foundation

class RankingEngine: InferenceEngine, InferenceDataDelegate {
    /// Adds the rank value of all contained statistics
    static var expFormula: ((StatisticsDatabase) -> Double) = {
        $0.statistics.values.map { $0.rankValue }.reduce(into: .zero) { $0 += $1 }
    }

    unowned var statisticsEngine: StatisticsEngine

    var statisticsDatabase: StatisticsDatabase { statisticsEngine.statistics }
    var currentExp: Double { Self.expFormula(statisticsDatabase) }
    var currentRank: Rank {
        Rank.allCases.first { $0.valueRange.contains(Int(self.currentExp)) } ?? .PRIVATE
    }

    init(_ statisticsEngine: StatisticsEngine) {
        self.statisticsEngine = statisticsEngine
    }

    func updateOnReceive() {  }
}
