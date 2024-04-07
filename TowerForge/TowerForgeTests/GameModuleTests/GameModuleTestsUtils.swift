//
//  GameModuleTestsUtils.swift
//  TowerForgeTests
//
//  Created by Zheng Ze on 7/4/24.
//

import Foundation
@testable import TowerForge

class TestComponentA: TFComponent {
    private(set) var didUpdate = false
    private(set) var didAddEntity = false
    private(set) var didRemoveEntity = false

    override func didAddToEntity(_ entity: TFEntity) {
        super.didAddToEntity(entity)
        didAddEntity = true
    }

    override func willRemoveFromEntity() {
        super.willRemoveFromEntity()
        didRemoveEntity = true
    }
}

class TestComponentB: TFComponent {
    private(set) var didUpdate = false
    private(set) var didAddEntity = false
    private(set) var didRemoveEntity = false

    override func didAddToEntity(_ entity: TFEntity) {
        super.didAddToEntity(entity)
        didAddEntity = true
    }

    override func willRemoveFromEntity() {
        super.willRemoveFromEntity()
        didRemoveEntity = true
    }
}

class TestEntity: TFEntity {}

class TestSystemA: TFSystem {
    var isActive = true
    var entityManager = EntityManager()
    var eventManager = EventManager()
    private(set) var didUpdate = false

    func update(within time: CGFloat) {
        didUpdate = true
    }
}

class TestSystemB: TFSystem {
    var isActive = true
    var entityManager = EntityManager()
    var eventManager = EventManager()
    private(set) var didUpdate = false

    func update(within time: CGFloat) {
        didUpdate = true
    }
}
