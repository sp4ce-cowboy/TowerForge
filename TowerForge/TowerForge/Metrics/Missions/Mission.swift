//
//  Mission.swift
//  TowerForge
//
//  Created by Rubesh on 15/4/24.
//

import Foundation

protocol Mission: AbstractGoal { }

extension Mission {
    static var asType: MissionTypeWrapper {
        MissionTypeWrapper(type: Self.self)
    }

    var currentValues: [StatisticTypeWrapper: Double] {
        var values: [StatisticTypeWrapper: Double] = [:]
        currentParameters.keys.forEach { key in
            if let currentStatistic = currentParameters[key] {
                values[key] = currentStatistic.maximumCurrentValue
            }
        }
        return values
    }
}
