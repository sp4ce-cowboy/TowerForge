//
//  RankingEngine.swift
//  TowerForge
//
//  Created by Rubesh on 16/4/24.
//

import Foundation

/// The RankingEngine is responsible for generating rank and exp information.
class RankingEngine: InferenceEngine, InferenceDataDelegate {
    unowned var statisticsEngine: StatisticsEngine

    static var defaultExpFormula: ((StatisticsDatabase) -> Double) = {
        $0.statistics.values.map { $0.rankValue }.reduce(into: .zero) { $0 += $1 }
    }

    init(_ statisticsEngine: StatisticsEngine) {
        self.statisticsEngine = statisticsEngine
    }

    deinit {
        Logger.log("DEINIT: RankingEngine is deinitialized", self)
    }

    var statisticsDatabase: StatisticsDatabase {
        statisticsEngine.statisticsDatabase
    }

    var currentExp: Double {
        Self.defaultExpFormula(statisticsDatabase)
    }

    var currentRank: Rank {
        Rank.allCases.first { $0.valueRange.contains(Int(self.currentExp)) } ?? .PRIVATE
    }

    var currentKd: Double {
        let kills = getPermanentValueFor(TotalKillsStatistic.self)
        let deaths = getPermanentValueFor(TotalDeathsStatistic.self)

        return kills > 0 && deaths > 0 ? kills / deaths : .zero
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

    func getPermanentValueFor<T: Statistic>(_ stat: T.Type) -> Double {
        statisticsDatabase.getStatistic(for: stat.asType)?.permanentValue ?? .zero
    }

    func updateOnReceive() {  }

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
