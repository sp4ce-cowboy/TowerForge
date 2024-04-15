//
//  InferenceEngineFactory.swift
//  TowerForge
//
//  Created by Rubesh on 15/4/24.
//

import Foundation

class InferenceEngineFactory {

    static var availableInferenceEngines: [(StatisticsEngine) -> any InferenceEngine] =
        [ 
            { stats in AchievementsEngine(stats) },
            { stats in MissionsEngine(stats) }
        ]
}
