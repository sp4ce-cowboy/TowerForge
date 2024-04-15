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
        case .PRIVATE:      return 0..<1001
        case .CORPORAL:     return 1001..<2001
        case .SERGEANT:     return 2001..<3001
        case .LIEUTENANT:   return 3001..<4001
        case .CAPTAIN:      return 4001..<5001
        case .MAJOR:        return 6001..<7001
        case .COLONEL:      return 7001..<8001
        case .GENERAL:      return 8001..<9001
        }
    }
}

