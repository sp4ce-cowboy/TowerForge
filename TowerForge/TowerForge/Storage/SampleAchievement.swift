//
//  SampleAchievement.swift
//  TowerForge
//
//  Created by Rubesh on 27/3/24.
//

import Foundation

class SampleAchievement: Storable {
    var killCount: Int = 0
    
    init(killCount: Int) {
        self.killCount = killCount
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.killCount = try container.decode(Int.self, forKey: .killCount)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.killCount, forKey: .killCount)
    }
    
    enum CodingKeys: CodingKey {
        case killCount
    }
    
    private func updateKillCount(_ count: Int) {
        killCount = count
    }
    
    func incrementKillCount() {
        killCount += 1
    }
    
    func decrementKillCount() {
        killCount -= 1
    }
}
