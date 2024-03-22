//
//  AiComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 19/03/24.
//

import Foundation
import UIKit

class AiComponent: TFComponent {
    private var entityManager: EntityManager
    private var chosenUnit: (BaseUnit & Spawnable).Type?
    init(entityManager: EntityManager) {
        self.entityManager = entityManager
        self.chosenUnit = SpawnableEntities.possibleUnits.randomElement()
        super.init()
    }

    override func update(deltaTime: TimeInterval) {
        guard let homeComponent = entity?.component(ofType: HomeComponent.self),
              let chosenUnit = chosenUnit else {
            return
        }

        // Generate random coordinates within the defined range
        let randomY = CGFloat.random(in: 0...UIScreen.main.bounds.height)

        if homeComponent.points >= chosenUnit.cost {
            let unit = UnitGenerator.spawn(ofType: chosenUnit,
                                           at: CGPoint(x: UIScreen.main.bounds.width,
                                                       y: randomY),
                                           player: .oppositePlayer,
                                           entityManager: entityManager)
            homeComponent.decreasePoints(chosenUnit.cost)

            // Re-randomize the unit
            self.chosenUnit = SpawnableEntities.possibleUnits.randomElement()
            entityManager.add(unit)
        }
    }
}
