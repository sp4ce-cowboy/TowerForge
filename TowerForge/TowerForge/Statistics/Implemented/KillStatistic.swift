//
//  KillStatistic.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

class KillStatistic: Statistic {

    var statisticName: StatisticName = .totalKills
    var statisticOriginalValue: Double = .zero
    var statisticAdditionalValue: Double = .zero

    var statisticUpdateLinks: StatisticUpdateLinkDatabase {
        self.getStatisticUpdateLinks()
    }

    init(statisticName: StatisticName,
         statisticOriginalValue: Double,
         statisticAdditionalValue: Double) {
        self.statisticName = statisticName
        self.statisticOriginalValue = statisticOriginalValue
        self.statisticAdditionalValue = statisticAdditionalValue
    }

    func getStatisticUpdateLinks() -> StatisticUpdateLinkDatabase {
        let eventType = TFEventTypeWrapper(type: KillEvent.self)
        let updateActor: StatisticUpdateActor = { statistic in statistic.updateAdditionalValue(by: 1.0) }
        let eventUpdateDictionary = [eventType: updateActor]
        let statsLink = StatisticUpdateLinkDatabase(statisticUpdateLinks: eventUpdateDictionary)

        return statsLink
    }

}
