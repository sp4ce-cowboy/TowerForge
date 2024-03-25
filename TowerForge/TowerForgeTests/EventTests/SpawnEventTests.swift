import Foundation
import XCTest
@testable import TowerForge

final class SpawnEventTests: XCTestCase {

    func test_initializeSpawnEvent() {
        let entityId = UUID()
        let timestamp = 1.0
        let entityType = MeleeUnit.self
        let position: CGPoint = .zero
        let player = Player.ownPlayer

        let entity = entityType.init(position: position, player: player)
        let spawnEvent = SpawnEvent(ofType: entityType, timestamp: timestamp, position: position, player: player)

        XCTAssertEqual(spawnEvent.timestamp, timestamp,
                       "SpawnEvent must have the same timestamp as originally specified")

        XCTAssertEqual(spawnEvent.entity.id, spawnEvent.entityId,
                       "Entity must have the same entityId as originally specified"
                       + "both within the SpawnEvent and outside")
    }

}
