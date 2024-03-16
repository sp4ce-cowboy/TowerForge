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

    init(on entityId: UUID, at timestamp: TimeInterval, with damage: CGFloat) {
        self.timestamp = timestamp
        self.entityId = entityId
        self.damage = damage
    }
    
    func execute(in target: any EventTarget) -> EventOutput {
        target.system(ofType: HealthSystem.self) // TODO: Handle Damge Event
        return EventOutput()
    }
}
