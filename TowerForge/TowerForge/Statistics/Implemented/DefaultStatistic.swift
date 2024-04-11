//
//  DefaultStatistic.swift
//  TowerForge
//
//  Created by Rubesh on 12/4/24.
//

import Foundation

final class DefaultStatistic: Statistic {

    var statisticName: StatisticName = .defaultStatistic
    var statisticValue: Double = .zero

    var statisticUpdateLinks: StatisticUpdateLinkDatabase {
        self.getStatisticUpdateLinks()
    }

    init(name: StatisticName = .defaultStatistic,
         value: Double = .zero) {
        self.statisticName = name
        self.statisticValue = value
    }

    func getStatisticUpdateLinks() -> StatisticUpdateLinkDatabase {
        let eventType = TFEventTypeWrapper(type: DisabledEvent.self)
        let updateActor: StatisticUpdateActor = { statistic in statistic.updateValue(by: 1.0) }
        let eventUpdateDictionary = [eventType: updateActor]
        let statsLink = StatisticUpdateLinkDatabase(statisticUpdateLinks: eventUpdateDictionary)

        return statsLink
    }

}
