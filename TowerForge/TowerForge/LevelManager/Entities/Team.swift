//
//  Team.swift
//  TowerForge
//
//  Created by MacBook Pro on 17/03/24.
//

import Foundation

class Team: TFEntity {
    static let lifeCount = 5
    static let pointsInterval = TimeInterval(0.5)
    override init() {
        super.init()
        createPlayerComponent()
    }
    private func createPlayerComponent() {
        let playerComponent = PlayerComponent(player: .ownPlayer, initialLifeCount: Team.lifeCount, pointInterval: Team.pointsInterval)
        self.addComponent(playerComponent)
    }
}
