//
//  InferenceEngine.swift
//  TowerForge
//
//  Created by Rubesh on 14/4/24.
//

import Foundation

protocol InferenceEngine: AnyObject {
    var statisticsEngine: StatisticsEngine { get set }
    func updateOnReceive()
}

extension InferenceEngine {
    static var asType: InferenceEngineTypeWrapper {
        InferenceEngineTypeWrapper(type: Self.self)
    }

    var asType: InferenceEngineTypeWrapper {
        InferenceEngineTypeWrapper(type: Self.self)
    }
}
