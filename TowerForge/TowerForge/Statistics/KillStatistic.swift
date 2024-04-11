//
//  KillStatistic.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

class KillStatistic: Statistic {
    

    var statisticName: StatisticName { .totalKills }

    var statisticOriginalValue: Double = 0.0
    var statisticAdditionalValue: Double = 0.0

    var eventLinks: [any TFEvent] = []

    var statisticValue: Double = 0.0

}
