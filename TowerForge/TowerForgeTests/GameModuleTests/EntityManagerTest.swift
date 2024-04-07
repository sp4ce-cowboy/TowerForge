//
//  EntityManagerTest.swift
//  TowerForgeTests
//
//  Created by Zheng Ze on 7/4/24.
//

import XCTest
@testable import TowerForge

final class EntityManagerTest: XCTestCase {
    func test_initializeEntityManager_containNoEntity() {
        let entityManager = EntityManager()
        XCTAssertEqual(entityManager.entities.count, 0)
    }

    func test_addEntity_entityIsAdded() {
        let entityManager = EntityManager()
        XCTAssertEqual(entityManager.entities.count, 0)

        let entity = TestEntity()
        entityManager.add(entity)
        XCTAssertEqual(entityManager.entities.count, 1)
        XCTAssertIdentical(entityManager.entity(with: entity.id), entity)
    }

    func test_addEntityMoreThanOnce_entityOnlyAddedOnce() {
        let entityManager = EntityManager()
        XCTAssertEqual(entityManager.entities.count, 0)

        let entity = TestEntity()
        entityManager.add(entity)
        XCTAssertEqual(entityManager.entities.count, 1)
        XCTAssertIdentical(entityManager.entity(with: entity.id), entity)

        entityManager.add(entity)
        XCTAssertEqual(entityManager.entities.count, 1)
    }

    func test_removeEntity_entityIsRemoved() {
        let entityManager = EntityManager()
        XCTAssertEqual(entityManager.entities.count, 0)

        let entityA = TestEntity()
        entityManager.add(entityA)
        XCTAssertEqual(entityManager.entities.count, 1)
        XCTAssertIdentical(entityManager.entity(with: entityA.id), entityA)

        entityManager.removeEntity(with: entityA.id)
        XCTAssertEqual(entityManager.entities.count, 0)
        XCTAssertNil(entityManager.entity(with: entityA.id))
    }

    func test_removeEntityWhenEntityIsNotPresent_noEntityIsRemoved() {
        let entityManager = EntityManager()
        XCTAssertEqual(entityManager.entities.count, 0)

        let entityA = TestEntity()
        entityManager.add(entityA)
        XCTAssertEqual(entityManager.entities.count, 1)
        XCTAssertIdentical(entityManager.entity(with: entityA.id), entityA)

        let entityB = TestEntity()

        XCTAssertNil(entityManager.entity(with: entityB.id))

        entityManager.removeEntity(with: entityB.id)
        XCTAssertEqual(entityManager.entities.count, 1)
        XCTAssertEqual(entityManager.entities.count, 1)
    }

    func test_componentOfEntity_componentIsRetrieved() {
        let entityManager = EntityManager()
        XCTAssertEqual(entityManager.entities.count, 0)

        let entity = TestEntity()
        let component = TestComponentA()
        entity.addComponent(component)
        entityManager.add(entity)

        XCTAssertEqual(entityManager.entities.count, 1)
        XCTAssertIdentical(entityManager.entity(with: entity.id), entity)

        XCTAssertIdentical(entityManager.component(ofType: TestComponentA.self, of: entity.id), component)
    }

    func test_unownedComponent_componentIsNotRetrieved() {
        let entityManager = EntityManager()
        XCTAssertEqual(entityManager.entities.count, 0)

        let entity = TestEntity()
        entityManager.add(entity)

        XCTAssertEqual(entityManager.entities.count, 1)
        XCTAssertIdentical(entityManager.entity(with: entity.id), entity)

        XCTAssertNil(entityManager.component(ofType: TestComponentA.self, of: entity.id))
    }

    func test_entitiesWithComponentsAdded_componentsRetrieved() {
        let entityManager = EntityManager()
        XCTAssertEqual(entityManager.entities.count, 0)

        let entityA = TestEntity()
        let entityB = TestEntity()
        let componentA = TestComponentA()
        let componentB = TestComponentA()
        entityA.addComponent(componentA)
        entityB.addComponent(componentB)

        entityManager.add(entityA)
        entityManager.add(entityB)

        XCTAssertEqual(entityManager.entities.count, 2)
        XCTAssertEqual(entityManager.components(ofType: TestComponentA.self).count, 2)
    }

    func test_entitiesWithNoComponentsAdded_noComponentsRetrieved() {
        let entityManager = EntityManager()
        XCTAssertEqual(entityManager.entities.count, 0)

        let entityA = TestEntity()
        let entityB = TestEntity()

        entityManager.add(entityA)
        entityManager.add(entityB)

        XCTAssertEqual(entityManager.entities.count, 2)
        XCTAssertEqual(entityManager.components(ofType: TestComponentA.self).count, 0)
    }
}
