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
                                               player: Player, entityManager: EntityManager) -> T {
        let unit = type.init(position: position, entityManager: entityManager, team: Team(player: player))
        return unit
    }
}
