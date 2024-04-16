//
//  RankingEnums.swift
//  TowerForge
//
//  Created by Rubesh on 16/4/24.
//

import Foundation

enum Rank: String, CaseIterable {
    case PRIVATE
    case CORPORAL
    case SERGEANT
    case LIEUTENANT
    case CAPTAIN
    case MAJOR
    case COLONEL
    case GENERAL

    var valueRange: Range<Int> {
        switch self {
        case .PRIVATE:      return 0..<1_001
        case .CORPORAL:     return 1_001..<2_001
        case .SERGEANT:     return 2_001..<3_001
        case .LIEUTENANT:   return 3_001..<4_001
        case .CAPTAIN:      return 4_001..<5_001
        case .MAJOR:        return 6_001..<7_001
        case .COLONEL:      return 7_001..<8_001
        case .GENERAL:      return 8_001..<9_001
        }
    }
}
