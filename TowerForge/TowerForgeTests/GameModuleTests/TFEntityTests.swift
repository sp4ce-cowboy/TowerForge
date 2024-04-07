//
//  TFEntityTests.swift
//  TowerForgeTests
//
//  Created by Zheng Ze on 7/4/24.
//

import XCTest
@testable import TowerForge

final class TFEntityTests: XCTestCase {
    func test_initializeEntity_shouldContainNoComponents() {
        let entity = TestEntity()
        XCTAssertNotNil(entity.id)
        XCTAssertEqual(entity.components.count, 0)
    }

    func test_addComponent_componentAdded() {
        let entity = TestEntity()
        let component = TestComponentA()

        XCTAssertEqual(entity.components.count, 0)

        entity.addComponent(component)
        XCTAssertEqual(entity.components.count, 1)
        XCTAssertIdentical(entity.component(ofType: TestComponentA.self), component)
        XCTAssertTrue(entity.hasComponent(ofType: TestComponentA.self))
    }

    func test_addMultipleComponentOfDifferentTypes_allComponentsAdded() {
        let entity = TestEntity()
        let componentA = TestComponentA()
        let componentB = TestComponentB()

        XCTAssertEqual(entity.components.count, 0)
        XCTAssertNil(entity.component(ofType: TestComponentA.self))
        XCTAssertNil(entity.component(ofType: TestComponentB.self))
        XCTAssertFalse(entity.hasComponent(ofType: TestComponentA.self))
        XCTAssertFalse(entity.hasComponent(ofType: TestComponentB.self))

        entity.addComponent(componentA)
        XCTAssertEqual(entity.components.count, 1)
        XCTAssertIdentical(entity.component(ofType: TestComponentA.self), componentA)
        XCTAssertNil(entity.component(ofType: TestComponentB.self))
        XCTAssertTrue(entity.hasComponent(ofType: TestComponentA.self))
        XCTAssertFalse(entity.hasComponent(ofType: TestComponentB.self))

        entity.addComponent(componentB)

        XCTAssertEqual(entity.components.count, 2)
        XCTAssertIdentical(entity.component(ofType: TestComponentA.self), componentA)
        XCTAssertIdentical(entity.component(ofType: TestComponentB.self), componentB)
        XCTAssertTrue(entity.hasComponent(ofType: TestComponentA.self))
        XCTAssertTrue(entity.hasComponent(ofType: TestComponentB.self))
    }

    func test_addMultipleComponentOfSameType_onlyFirstAdded() {
        let entity = TestEntity()
        let componentA = TestComponentA()
        let componentB = TestComponentA()

        XCTAssertEqual(entity.components.count, 0)

        entity.addComponent(componentA)
        XCTAssertEqual(entity.components.count, 1)
        XCTAssertIdentical(entity.component(ofType: TestComponentA.self), componentA)
        XCTAssertNotIdentical(entity.component(ofType: TestComponentA.self), componentB)
        XCTAssertTrue(entity.hasComponent(ofType: TestComponentA.self))

        entity.addComponent(componentB)

        XCTAssertEqual(entity.components.count, 1)
        XCTAssertIdentical(entity.component(ofType: TestComponentA.self), componentA)
        XCTAssertNotIdentical(entity.component(ofType: TestComponentA.self), componentB)
        XCTAssertTrue(entity.hasComponent(ofType: TestComponentA.self))
    }

    func test_removeComponent_componentIsRemoved() {
        let entity = TestEntity()
        let component = TestComponentA()

        XCTAssertEqual(entity.components.count, 0)
        XCTAssertNil(entity.component(ofType: TestComponentA.self))
        XCTAssertFalse(entity.hasComponent(ofType: TestComponentA.self))

        entity.addComponent(component)

        XCTAssertEqual(entity.components.count, 1)
        XCTAssertIdentical(entity.component(ofType: TestComponentA.self), component)
        XCTAssertTrue(entity.hasComponent(ofType: TestComponentA.self))

        entity.removeComponent(ofType: TestComponentA.self)

        XCTAssertEqual(entity.components.count, 0)
        XCTAssertNil(entity.component(ofType: TestComponentA.self))
        XCTAssertFalse(entity.hasComponent(ofType: TestComponentA.self))
    }

    func test_removeComponentThatDoesNotExist_noComponentRemoved() {
        let entity = TestEntity()
        let component = TestComponentA()

        XCTAssertEqual(entity.components.count, 0)
        XCTAssertNil(entity.component(ofType: TestComponentA.self))
        XCTAssertNil(entity.component(ofType: TestComponentB.self))
        XCTAssertFalse(entity.hasComponent(ofType: TestComponentA.self))
        XCTAssertFalse(entity.hasComponent(ofType: TestComponentB.self))

        entity.addComponent(component)

        XCTAssertEqual(entity.components.count, 1)
        XCTAssertIdentical(entity.component(ofType: TestComponentA.self), component)
        XCTAssertNil(entity.component(ofType: TestComponentB.self))
        XCTAssertTrue(entity.hasComponent(ofType: TestComponentA.self))
        XCTAssertFalse(entity.hasComponent(ofType: TestComponentB.self))

        entity.removeComponent(ofType: TestComponentB.self)

        XCTAssertEqual(entity.components.count, 1)
        XCTAssertIdentical(entity.component(ofType: TestComponentA.self), component)
        XCTAssertNil(entity.component(ofType: TestComponentB.self))
        XCTAssertTrue(entity.hasComponent(ofType: TestComponentA.self))
        XCTAssertFalse(entity.hasComponent(ofType: TestComponentB.self))
    }

    func test_addComponent_shouldCallDidAddToEntityOnComponent() {
        let entity = TestEntity()
        let component = TestComponentA()

        XCTAssertFalse(component.didAddEntity)

        entity.addComponent(component)

        XCTAssertTrue(component.didAddEntity)
    }

    func test_removeComponent_shouldCallWillRemoveEntityOnComponent() {
        let entity = TestEntity()
        let component = TestComponentA()
        entity.addComponent(component)

        XCTAssertFalse(component.didRemoveEntity)

        entity.removeComponent(ofType: TestComponentA.self)

        XCTAssertTrue(component.didRemoveEntity)
    }
}
