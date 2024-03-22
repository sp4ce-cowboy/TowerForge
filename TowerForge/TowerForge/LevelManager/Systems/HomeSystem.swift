//
//  HomeSystem.swift
//  TowerForge
//
//  Created by Zheng Ze on 23/3/24.
//

import Foundation

class HomeSystem: TFSystem {
    var isActive = true
    weak var entityManager: EntityManager?
    weak var eventManager: EventManager?

    init(entityManager: EntityManager) {
        self.entityManager = entityManager
    }

    func update(within time: CGFloat) {
        guard let entityManager = entityManager else {
            return
        }

        let homeComponents = entityManager.components(ofType: HomeComponent.self)
        for homeComponent in homeComponents {
            homeComponent.update(deltaTime: time)
        }
    }
}
