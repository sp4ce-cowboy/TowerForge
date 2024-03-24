import Foundation
import XCTest
@testable import TowerForge

final class RemoveEventTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_initializeRemoveEvent() {
        let entityId = UUID()
        let timestamp = 1.0

        let removeEvent = RemoveEvent(on: entityId, at: timestamp)

        XCTAssertEqual(removeEvent.timestamp, timestamp,
                       "RemoveEvent must have the same timestamp as originally specified")

        XCTAssertEqual(removeEvent.entityId, entityId,
                       "RemoveEvent must have the same entityId as originally specified")
    }

}
