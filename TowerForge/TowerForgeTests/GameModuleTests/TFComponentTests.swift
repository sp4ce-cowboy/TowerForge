//
//  TFComponentTests.swift
//  TowerForgeTests
//
//  Created by Zheng Ze on 7/4/24.
//

import XCTest
@testable import TowerForge

final class TFComponentTests: XCTestCase {
    func test_initialise_shouldContainsIdAndNoEntity() {
        let component = TFComponent()

        XCTAssertNotNil(component.id)
        XCTAssertNil(component.entity)
    }

    func test_addToEntity_shouldContainReferenceToEntity() {
        let entity = TestEntity()
        let component = TFComponent()

        XCTAssertNil(component.entity)

        entity.addComponent(component)

        XCTAssertNotNil(component.entity)
    }

    func test_removeFromEntity_shouldNotContainReferenceToEntity() {
        let entity = TestEntity()
        let component = TFComponent()

        XCTAssertNil(component.entity)

        entity.addComponent(component)

        XCTAssertNotNil(component.entity)

        entity.removeComponent(ofType: TFComponent.self)

        XCTAssertNil(component.entity)
    }
}
