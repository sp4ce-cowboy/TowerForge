//
//  TotalDeathsStatistic.swift
//  TowerForge
//
//  Created by Rubesh on 12/4/24.
//

import Foundation

final class TotalDeathsStatistic: Statistic {

    var statisticName: StatisticName = .totalDeaths
    var statisticValue: Double = .zero

    var statisticUpdateLinks: StatisticUpdateLinkDatabase {
        self.getStatisticUpdateLinks()
    }

    init(name: StatisticName = .totalDeaths,
         value: Double = .zero) {
        self.statisticName = name
        self.statisticValue = value
    }

    func getStatisticUpdateLinks() -> StatisticUpdateLinkDatabase {
        let eventType = TFEventTypeWrapper(type: DeathEvent.self)
        let updateActor: StatisticUpdateActor = { statistic in statistic.updateValue(by: 1.0) }
        let eventUpdateDictionary = [eventType: updateActor]
        let statsLink = StatisticUpdateLinkDatabase(statisticUpdateLinks: eventUpdateDictionary)

        return statsLink
    }

}
