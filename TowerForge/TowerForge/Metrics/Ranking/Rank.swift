//
//  RankingEnums.swift
//  TowerForge
//
//  Created by Rubesh on 16/4/24.
//

import Foundation

enum Rank: String, CaseIterable, Comparable {
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
        case .PRIVATE:      return 0..<10_001
        case .CORPORAL:     return 10_001..<20_001
        case .SERGEANT:     return 20_001..<30_001
        case .LIEUTENANT:   return 30_001..<50_001
        case .CAPTAIN:      return 50_001..<100_001
        case .MAJOR:        return 100_001..<300_001
        case .COLONEL:      return 300_001..<800_001
        case .GENERAL:      return 800_001..<Int.max
        }
    }

    var imageIdentifer: String {
        switch self {
        case .PRIVATE:      return "private"
        case .CORPORAL:     return "corporal"
        case .SERGEANT:     return "sergeant"
        case .LIEUTENANT:   return "lieutenant"
        case .CAPTAIN:      return "captain"
        case .MAJOR:        return "major"
        case .COLONEL:      return "colonel"
        case .GENERAL:      return "general"
        }
    }

    static func < (lhs: Rank, rhs: Rank) -> Bool {
        allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
    }

    func isOfficer() -> Bool {
        self > .SERGEANT
    }
}
