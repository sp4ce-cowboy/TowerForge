//
//  InferenceEngine.swift
//  TowerForge
//
//  Created by Rubesh on 14/4/24.
//

import Foundation

protocol InferenceEngine: AnyObject {
    func updateOnReceive(stats: StatisticsDatabase)
}
