//
//  UnitGenerator.swift
//  TowerForge
//
//  Created by Vanessa Mae on 19/03/24.
//

import Foundation

class UnitGenerator {
    static func spawnMelee(at position: CGPoint, player: Player, entityManager: EntityManager) {
        // TODO: Change the default value and abstract as constant
        let unit = MeleeUnit(position: position,
                             entityManager: entityManager,
                             attackRate: 10.0,
                             velocity: CGVector(dx: 1.0, dy: 0.0),
                             team: Team(player: .oppositePlayer))
        let spriteComponent = unit.component(ofType: SpriteComponent.self)
        spriteComponent?.node.position = position
        entityManager.add(unit)
    }
    static func spawnSoldier(at position: CGPoint, player: Player, entityManager: EntityManager) {
        // TODO: Change the default value and abstract as constant
        let unit = SoldierUnit(position: position,
                               entityManager: entityManager,
                               attackRate: 10.0,
                               velocity: CGVector(dx: 1.0, dy: 0.0),
                               team: Team(player: .oppositePlayer))
        let spriteComponent = unit.component(ofType: SpriteComponent.self)
        spriteComponent?.node.position = position
        entityManager.add(unit)
    }
}
