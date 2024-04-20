//
//  RankingEngine.swift
//  TowerForge
//
//  Created by Rubesh on 16/4/24.
//

import Foundation

/// The RankingEngine is responsible for generating rank and exp information.
class RankingEngine: InferenceEngine, InferenceDataDelegate {

    // TODO: Consider expanding to more formula for .e.g double exp.
    static var defaultExpFormula: ((StatisticsDatabase) -> Double) = {
        $0.statistics.values.map { $0.rankValue }.reduce(into: .zero) { $0 += $1 }
    }

    unowned var statisticsEngine: StatisticsEngine

    var statisticsDatabase: StatisticsDatabase {
        statisticsEngine.statistics
    }

    var currentExp: Double {
        Self.defaultExpFormula(statisticsDatabase)
    }

    var currentRank: Rank {
        Rank.allCases.first { $0.valueRange.contains(Int(self.currentExp)) } ?? .PRIVATE
    }

    var currentKd: Double {
        getPermanentValueFor(TotalKillsStatistic.self) / getPermanentValueFor(TotalDeathsStatistic.self)
    }

    var currentExpAsString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        let number = Int(currentExp)
        let formattedString = numberFormatter.string(from: NSNumber(value: number)) ?? ""
        return formattedString
    }

    var isOfficer: Bool {
        currentRank.isOfficer()
    }

    init(_ statisticsEngine: StatisticsEngine) {
        self.statisticsEngine = statisticsEngine
    }

    func updateOnReceive() {  }

    func getPermanentValueFor<T: Statistic>(_ stat: T.Type) -> Double {
        statisticsDatabase.getStatistic(for: stat.asType)?.permanentValue ?? .zero
    }

    func percentageToNextRank() -> Double {
        let minScore = currentRank.valueRange.lowerBound
        let currentScore = Int(currentExp)
        let maxScore = currentRank.valueRange.upperBound
        let range = Double(maxScore - minScore)
        let adjustedScore = Double(currentScore - minScore)
        let percentageToNextRank = adjustedScore / range

        return percentageToNextRank

    }
}
