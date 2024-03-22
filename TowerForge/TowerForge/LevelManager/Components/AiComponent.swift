//
//  AiComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 19/03/24.
//

import Foundation
import UIKit

class AiComponent: TFComponent {
    private var chosenUnit: (TFEntity & PlayerSpawnable).Type?

    override init() {
        self.chosenUnit = SpawnableEntities.playerSpawnableEntities.randomElement()
        super.init()
    }

    func spawn() -> TFEvent? {
        guard let homeComponent = entity?.component(ofType: HomeComponent.self),
              let chosenUnit = chosenUnit else {
            return nil
        }
        let randomY = CGFloat.random(in: 0...UIScreen.main.bounds.height)

        guard homeComponent.points >= chosenUnit.cost else {
            return nil
        }
        homeComponent.decreasePoints(chosenUnit.cost)

        // Re-randomize the unit
        self.chosenUnit = SpawnableEntities.playerSpawnableEntities.randomElement()
        return SpawnEvent(ofType: chosenUnit, timestamp: CACurrentMediaTime(),
                          position: CGPoint(x: UIScreen.main.bounds.width, y: randomY), player: .oppositePlayer)
    }
}
