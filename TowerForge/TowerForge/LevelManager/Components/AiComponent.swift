//
//  AiComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 19/03/24.
//

import Foundation

class AiComponent: TFComponent {
    private var entityManager: EntityManager
    private var chosenUnit: (TFEntity & PlayerSpawnable).Type?
    init(entityManager: EntityManager) {
        self.entityManager = entityManager
        self.chosenUnit = SpawnableEntities.playerSpawnableEntities.randomElement()
        super.init()
    }

    override func update(deltaTime: TimeInterval) {
        guard let homeComponent = entity?.component(ofType: HomeComponent.self), let chosenUnit = chosenUnit else {
            return
        }
        let unit = UnitGenerator.spawn(ofType: chosenUnit, at: CGPoint(x: 0, y: 10), player: .oppositePlayer)
        entityManager.add(unit)
    }
}
