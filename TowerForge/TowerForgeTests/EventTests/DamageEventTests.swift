import Foundation
import XCTest
@testable import TowerForge

final class DamageEventTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_initializeDamageEvent() {
        let entityId = UUID()
        let timestamp = 1.0
        let damage = 10.0
        let damageEvent = DamageEvent(on: entityId, at: timestamp, with: damage)

        XCTAssertEqual(damageEvent.timestamp, timestamp,
                       "DamageEvent must have the same timestamp as originally specified")

        XCTAssertEqual(damageEvent.damage, damage,
                       "DamageEvent must have the same damage as originally specified")

        XCTAssertEqual(damageEvent.entityId, entityId,
                       "DamageEvent must have the same entityId as originally specified")
    }

}
