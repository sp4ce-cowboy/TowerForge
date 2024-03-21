//
//  UnitGenerator.swift
//  TowerForge
//
//  Created by Vanessa Mae on 19/03/24.
//

import Foundation
import SpriteKit

class UnitGenerator {
    static func spawn<T: BaseUnit & Spawnable>(ofType type: T.Type, at position: CGPoint,
                                               player: Player, entityManager: EntityManager, scene: SKScene) {
        let unit = type.init(position: position, entityManager: entityManager, team: Team(player: player))
        let spriteComponent = unit.component(ofType: SpriteComponent.self)
        spriteComponent?.node.position = position
        entityManager.add(unit)
        if let node = spriteComponent?.node {
            scene.addChild(node)
            node.playAnimation()
        }
    }
}
