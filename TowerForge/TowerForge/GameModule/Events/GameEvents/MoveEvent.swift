import Foundation

struct MoveEvent: TFEvent {
    let timestamp: TimeInterval
    let entityId: UUID
    let displacement: CGVector

    init(on entityId: UUID, at timestamp: TimeInterval, with displacement: CGVector) {
        self.entityId = entityId
        self.timestamp = timestamp
        self.displacement = displacement
    }

    func execute(in target: any EventTarget) -> EventOutput {
        if let movementSystem = target.system(ofType: MovementSystem.self) {
            movementSystem.handleMovement(for: entityId, with: displacement)
        }
        return EventOutput()
    }
}
