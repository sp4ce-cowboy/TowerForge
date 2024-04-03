//
//  LifeEvent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 27/03/24.
//

import Foundation

struct LifeEvent: TFEvent {
    let timestamp: TimeInterval
    let entityId: UUID
    let lifeDecrease: Int
    let player: Player

    init(on entityId: UUID, at timestamp: TimeInterval, reduceBy: Int, player: Player) {
        self.timestamp = timestamp
        self.entityId = entityId
        self.lifeDecrease = reduceBy
        self.player = player
    }

    func execute(in target: any EventTarget) -> EventOutput {
        if let homeSystem = target.system(ofType: HomeSystem.self) {
            homeSystem.reduceLife(for: player.getOppositePlayer(), reduction: lifeDecrease)
        }
        return EventOutput()
    }
}
