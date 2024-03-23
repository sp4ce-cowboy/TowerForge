//
//  Team.swift
//  TowerForge
//
//  Created by Vanessa Mae on 17/03/24.
//

import Foundation

class Team: TFEntity {
    static let lifeCount = 5
    static let pointsInterval = TimeInterval(0.5)
    var player: Player
    init(player: Player, entityManager: EntityManager) {
        self.player = player
        super.init()
        createPlayerComponent(player: player)
        createHomeComponent()

        if player == .oppositePlayer {
            self.addComponent(AiComponent(entityManager: entityManager))
        } else {
            self.addComponent(LabelComponent(text: String(0)))
        }
    }
    private func createHomeComponent() {
        let homeComponent = HomeComponent(initialLifeCount: Team.lifeCount, pointInterval: Team.pointsInterval)
        self.addComponent(homeComponent)
    }
    private func createPlayerComponent(player: Player) {
        let playerComponent = PlayerComponent(player: player)
        self.addComponent(playerComponent)
    }
}
