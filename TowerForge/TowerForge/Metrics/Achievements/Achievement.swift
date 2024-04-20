//
//  TFAchievement.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

protocol Achievement: AbstractGoal { }

extension Achievement {
    var imageIdentifier: String { "coin" }

    static var asType: AchievementTypeWrapper {
        AchievementTypeWrapper(type: Self.self)
    }

    var currentValues: [StatisticTypeWrapper: Double] {
        var values: [StatisticTypeWrapper: Double] = [:]
        currentParameters.keys.forEach { key in
            if let currentStatistic = currentParameters[key] {
                values[key] = currentStatistic.permanentValue
            }
        }
        return values
    }
}
