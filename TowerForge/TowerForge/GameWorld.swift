//
//  GameWorld.swift
//  TowerForge
//
//  Created by Zheng Ze on 20/3/24.
//

import Foundation

class GameWorld {
    private unowned var scene: GameScene?
    private var entityManager: EntityManager
    private var systemManager: SystemManager
    private var eventManager: EventManager

    init(scene: GameScene?) {
        entityManager = EntityManager()
        systemManager = SystemManager()
        eventManager = EventManager()

        // Temporary for testing
        let meleeUnit = MeleeUnit(position: CGPoint(x: 0, y: 100),
                                  entityManager: entityManager, attackRate: 1.0,
                                  velocity: CGVector(dx: 10.0, dy: 0.0),
                                  team: Team(player: .ownPlayer))

        let soldierUnit = SoldierUnit(position: CGPoint(x: 0, y: 50), entityManager: entityManager,
                                      attackRate: 1.0,
                                      velocity: CGVector(dx: 10.0, dy: 0.0),
                                      team: Team(player: .ownPlayer))

        let arrowTower = ArrowTower(position: CGPoint(x: 0, y: 100), entityManager: entityManager)

        entityManager.add(meleeUnit)
        entityManager.add(soldierUnit)
        entityManager.add(arrowTower)
        guard let sprite = meleeUnit.component(ofType: SpriteComponent.self),
             let soldierSprite = soldierUnit.component(ofType: SpriteComponent.self),
        let arrowTowerSprite = arrowTower.component(ofType: SpriteComponent.self) else {
            return
        }
        scene?.addChild(sprite.node)
        scene?.addChild(soldierSprite.node)
        scene?.addChild(arrowTowerSprite.node)
        sprite.node.playAnimation()
        soldierSprite.node.playAnimation()
    }

    func update(deltaTime: TimeInterval) {
        systemManager.update(deltaTime)
        eventManager.executeEvents(in: self)
        entityManager.update(deltaTime)
    }
}

extension GameWorld: EventTarget {
    func system<T: TFSystem>(ofType type: T.Type) -> T? {
        systemManager.system(ofType: type)
    }
}
