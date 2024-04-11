//
//  StatisticsDatabase.swift
//  TowerForge
//
//  Created by Rubesh on 12/4/24.
//

import Foundation

class StatisticsDatabase {
    var statistics: [StatisticName: Statistic] = [:]
    
    init(statistics: [StatisticName: Statistic] = [:]) {
        self.statistics = statistics
    }
    
    func getStatistic(for statName: StatisticName) -> Statistic? {
        statistics[statName]
    }
    
    func load() {
        // TODO: Implement load
    }
    
    func save() {
        // TODO: Implement save
    }
    
}
