//
//  KillStatistic.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

class KillStatistic: Statistic {

    var statisticName: StatisticName = .totalKills

    var statisticUpdateLinks: StatisticUpdateLinkDatabase = StatisticUpdateLinkFactory.getKillStatisticLinks()
    var statisticOriginalValue: Double = .zero
    var statisticAdditionalValue: Double = .zero

    init(statisticName: StatisticName,
         statisticUpdateLinks: StatisticUpdateLinkDatabase,
         statisticOriginalValue: Double,
         statisticAdditionalValue: Double) {
        self.statisticName = statisticName
        self.statisticUpdateLinks = statisticUpdateLinks
        self.statisticOriginalValue = statisticOriginalValue
        self.statisticAdditionalValue = statisticAdditionalValue
    }

    func update(for eventType: TFEventTypeWrapper) {

    }

}
