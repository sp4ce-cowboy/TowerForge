//
//  DamageEvent.swift
//  TowerForge
//
//  Created by Zheng Ze on 16/3/24.
//

import Foundation

// Should generate this on collision between an entity with a damage component and a health component
struct DamageEvent: TFEvent {
    let timestamp: TimeInterval
    let entityId: UUID
    let damage: CGFloat
    let player: Player

    init(on entityId: UUID, at timestamp: TimeInterval, with damage: CGFloat, player: Player) {
        self.timestamp = timestamp
        self.entityId = entityId
        self.damage = damage
        self.player = player
    }

    func execute(in target: any EventTarget) -> EventOutput {
        if let healthSystem = target.system(ofType: HealthSystem.self) {
            healthSystem.modifyHealth(for: entityId, with: -damage)
        }
        return EventOutput()
    }
}
