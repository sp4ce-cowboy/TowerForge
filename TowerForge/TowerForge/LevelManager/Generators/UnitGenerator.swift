//
//  UnitGenerator.swift
//  TowerForge
//
//  Created by Vanessa Mae on 19/03/24.
//

import Foundation
import SpriteKit

class UnitGenerator {
    public static func spawnUnit(ofType type: UnitType, at position: CGPoint, player: Player, entityManager: EntityManager, scene: SKScene) {
            switch type {
            case .melee:
                spawnMelee(at: position, player: player, entityManager: entityManager, scene: scene)
            case .soldier:
                spawnSoldier(at: position, player: player, entityManager: entityManager, scene: scene)
            }
        }
    public static func spawnMelee(at position: CGPoint, player: Player, entityManager: EntityManager, scene: SKScene) {
        // TODO: Change the default value and abstract as constant
        let unit = MeleeUnit(position: position,
                             entityManager: entityManager,
                             attackRate: 10.0,
                             velocity: CGVector(dx: 10.0, dy: 0.0),
                             team: Team(player: player))
        let spriteComponent = unit.component(ofType: SpriteComponent.self)
        spriteComponent?.node.position = position
        entityManager.add(unit)
        if let node = spriteComponent?.node {
            scene.addChild(node)
            node.playAnimation()
        }
    }
    public static func spawnSoldier(at position: CGPoint, player: Player, entityManager: EntityManager, scene: SKScene) {
        // TODO: Change the default value and abstract as constant
        let unit = SoldierUnit(position: position,
                               entityManager: entityManager,
                               attackRate: 10.0,
                               velocity: CGVector(dx: 10.0, dy: 0.0),
                               team: Team(player: player))
        let spriteComponent = unit.component(ofType: SpriteComponent.self)
        spriteComponent?.node.position = position
        entityManager.add(unit)
        if let node = spriteComponent?.node {
            scene.addChild(node)
            node.playAnimation()
        }
    }
}
