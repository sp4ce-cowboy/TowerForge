//
//  KillStatistic.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

final class KillStatistic: Statistic {

    var statisticName: StatisticName = .totalKills
    var statisticValue: Double = .zero

    var statisticUpdateLinks: StatisticUpdateLinkDatabase {
        self.getStatisticUpdateLinks()
    }

    init(name: StatisticName = .totalKills,
         value: Double = .zero) {
        self.statisticName = name
        self.statisticValue = value
    }

    func getStatisticUpdateLinks() -> StatisticUpdateLinkDatabase {
        let eventType = TFEventTypeWrapper(type: KillEvent.self)
        let updateActor: StatisticUpdateActor = { statistic in statistic.updateValue(by: 1.0) }
        let eventUpdateDictionary = [eventType: updateActor]
        let statsLink = StatisticUpdateLinkDatabase(statisticUpdateLinks: eventUpdateDictionary)

        return statsLink
    }

}
