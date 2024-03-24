import Foundation
import XCTest
@testable import TowerForge

final class RequestSpawnEventTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_initializeRequestSpawnEvent() {
        let timestamp = 1.0
        let entityType = MeleeUnit.self
        let position: CGPoint = .zero
        let player = Player.ownPlayer

        let requestSpawnEvent = RequestSpawnEvent(ofType: entityType,
                                                  timestamp: timestamp,
                                                  position: position, player: player)

        XCTAssertEqual(requestSpawnEvent.timestamp, timestamp,
                       "RequestSpawnEvent must have the same timestamp as originally specified")

        XCTAssertEqual(requestSpawnEvent.position, position,
                       "RequestSpawnEvent must have the same position as specified.")

        // MeleeUnit does not conform to equatable so XCAssertEqual cannot be used here
        XCTAssertTrue(requestSpawnEvent.entityType == entityType,
                       "RequestSpawnEvent must have the same entity type as specified.")

        // XCTAssertThrowsError(requestSpawnEvent.entityId, "Retrieving ID must throw fatal error")

    }

}
