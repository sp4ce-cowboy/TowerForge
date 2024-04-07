//
//  SystemManagerTests.swift
//  TowerForgeTests
//
//  Created by Zheng Ze on 7/4/24.
//

import XCTest
@testable import TowerForge

final class SystemManagerTests: XCTestCase {
    func test_initializeSystemManager_noSystemsAdded() {
        let systemManager = SystemManager()
        XCTAssertEqual(systemManager.systems.values.count, 0)
    }

    func test_addSystem_systemIsAdded() {
        let systemManager = SystemManager()

        XCTAssertEqual(systemManager.systems.values.count, 0)

        let system = TestSystemA()
        systemManager.add(system: system)

        XCTAssertEqual(systemManager.systems.values.count, 1)
        XCTAssertNotNil(systemManager.system(ofType: TestSystemA.self))
        XCTAssertIdentical(systemManager.system(ofType: TestSystemA.self), system)
    }

    func test_addMultipleDifferentSystems_allSystemsAreAdded() {
        let systemManager = SystemManager()

        XCTAssertEqual(systemManager.systems.values.count, 0)

        let systemA = TestSystemA()
        systemManager.add(system: systemA)

        XCTAssertEqual(systemManager.systems.values.count, 1)
        XCTAssertNotNil(systemManager.system(ofType: TestSystemA.self))
        XCTAssertIdentical(systemManager.system(ofType: TestSystemA.self), systemA)

        let systemB = TestSystemB()
        systemManager.add(system: systemB)

        XCTAssertEqual(systemManager.systems.values.count, 2)
        XCTAssertNotNil(systemManager.system(ofType: TestSystemA.self))
        XCTAssertIdentical(systemManager.system(ofType: TestSystemA.self), systemA)
        XCTAssertNotNil(systemManager.system(ofType: TestSystemB.self))
        XCTAssertIdentical(systemManager.system(ofType: TestSystemB.self), systemB)
    }

    func test_addMultipleSystemOfSameType_onlyFirstSystemAdded() {
        let systemManager = SystemManager()

        XCTAssertEqual(systemManager.systems.values.count, 0)

        let systemA = TestSystemA()
        systemManager.add(system: systemA)

        XCTAssertEqual(systemManager.systems.values.count, 1)
        XCTAssertNotNil(systemManager.system(ofType: TestSystemA.self))
        XCTAssertIdentical(systemManager.system(ofType: TestSystemA.self), systemA)

        let systemB = TestSystemA()
        systemManager.add(system: systemB)

        XCTAssertEqual(systemManager.systems.values.count, 1)
        XCTAssertNotNil(systemManager.system(ofType: TestSystemA.self))
        XCTAssertIdentical(systemManager.system(ofType: TestSystemA.self), systemA)
        XCTAssertNotIdentical(systemManager.system(ofType: TestSystemA.self), systemB)
    }

    func test_deleteSystem_systemIsDeleted() {
        let systemManager = SystemManager()

        XCTAssertEqual(systemManager.systems.values.count, 0)

        let system = TestSystemA()
        systemManager.add(system: system)

        XCTAssertEqual(systemManager.systems.values.count, 1)
        XCTAssertNotNil(systemManager.system(ofType: TestSystemA.self))
        XCTAssertIdentical(systemManager.system(ofType: TestSystemA.self), system)

        systemManager.remove(ofType: TestSystemA.self)

        XCTAssertEqual(systemManager.systems.values.count, 0)
        XCTAssertNil(systemManager.system(ofType: TestSystemA.self))
    }

    func test_deleteSystemWhenSystemOfSameTypeNotInSystemManager_noSytemsDeleted() {
        let systemManager = SystemManager()

        XCTAssertEqual(systemManager.systems.values.count, 0)

        let system = TestSystemA()
        systemManager.add(system: system)

        XCTAssertEqual(systemManager.systems.values.count, 1)
        XCTAssertNotNil(systemManager.system(ofType: TestSystemA.self))
        XCTAssertIdentical(systemManager.system(ofType: TestSystemA.self), system)

        systemManager.remove(ofType: TestSystemB.self)

        XCTAssertEqual(systemManager.systems.values.count, 1)
        XCTAssertNotNil(systemManager.system(ofType: TestSystemA.self))
        XCTAssertIdentical(systemManager.system(ofType: TestSystemA.self), system)
    }

    func test_updateCalledInSystemManager_systemsUpdateIsCalled() {
        let systemManager = SystemManager()
        let system = TestSystemA()
        systemManager.add(system: system)

        XCTAssertFalse(system.didUpdate)

        systemManager.update(10)

        XCTAssertTrue(system.didUpdate)
    }
}
