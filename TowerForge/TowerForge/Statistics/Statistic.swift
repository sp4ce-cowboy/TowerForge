//
//  Statistic.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

protocol Statistic {
    var statisticName: String { get }
    var statisticValue: Double { get set }
}

extension Statistic {
    mutating func incrementStat(by amount: Double) {
        self.statisticValue += amount
    }
    
    mutating func incrementStatByOne() {
        incrementStat(by: 1.0)
    }
}
