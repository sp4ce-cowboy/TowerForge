//
//  AiComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 19/03/24.
//

import Foundation

enum UnitType {
    case melee
    case soldier
    static let possibleUnits = [melee, soldier]
}

class AiComponent: TFComponent {
    private var entityManager: EntityManager
    private var chosenUnit: UnitType
    init(entityManager: EntityManager) {
        self.entityManager = entityManager
        self.chosenUnit = UnitType.possibleUnits.randomElement() ?? .melee
        super.init()
    }
    
    override func update(deltaTime: TimeInterval) {
        guard let homeComponent = entity?.component(ofType: HomeComponent.self) else {
            return
        }
        if chosenUnit == .melee && homeComponent.points >= MeleeUnit.cost {
            // TODO: Remove hard code of CGPoints
            UnitGenerator.spawnMelee(at: CGPoint(x: 0, y: 10), player: .oppositePlayer, entityManager: entityManager)
            self.chosenUnit = UnitType.possibleUnits.randomElement() ?? .melee
        }
        if chosenUnit == .soldier && homeComponent.points >= SoldierUnit.cost {
            // TODO: Remove hard code of CGPoints
            UnitGenerator.spawnSoldier(at: CGPoint(x: 0, y: 10), player: .oppositePlayer, entityManager: entityManager)
            self.chosenUnit = UnitType.possibleUnits.randomElement() ?? .melee
        }
    }
}
