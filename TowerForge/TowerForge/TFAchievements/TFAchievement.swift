//
//  TFAchievement.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

/// The TFAchievement protocol specifies the requirements for all concrete
/// achievements to conform to. 
protocol TFAchievement {
    var achievementName: String { get }
    var achievementDescription: String { get }
    
    var isComplete: Bool { get }
    
    
    
}
