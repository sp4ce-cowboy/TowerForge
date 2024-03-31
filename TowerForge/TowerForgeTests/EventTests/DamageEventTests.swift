import Foundation
import XCTest
@testable import TowerForge

final class DamageEventTests: XCTestCase {

    func test_initializeDamageEvent() {
        let entityId = UUID()
        let timestamp = 1.0
        let damage = 10.0
        let player = Player.ownPlayer
        let damageEvent = DamageEvent(on: entityId, at: timestamp, with: damage, player: player)

        XCTAssertEqual(damageEvent.timestamp, timestamp,
                       "DamageEvent must have the same timestamp as originally specified")

        XCTAssertEqual(damageEvent.damage, damage,
                       "DamageEvent must have the same damage as originally specified")

        XCTAssertEqual(damageEvent.entityId, entityId,
                       "DamageEvent must have the same entityId as originally specified")

        XCTAssertEqual(damageEvent.entityId, entityId,
                       "DamageEvent must have the same player as originally specified")
    }

}
