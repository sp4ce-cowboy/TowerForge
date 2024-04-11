//
//  StatisticEnums.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

typealias StatisticName = StatisticEnums.StatisticName
class StatisticEnums {

    enum StatisticName: String, Codable, CaseIterable {
        case defaultStatistic
        case totalKills
        case totalGamesPlayed
        case totalDeaths
    }
}
