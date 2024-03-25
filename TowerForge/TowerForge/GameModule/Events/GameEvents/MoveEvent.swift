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

    func execute(in target: any EventTarget) -> EventOutput? {
        guard let movementSystem = target.system(ofType: MovementSystem.self) else {
            return nil
        }
        movementSystem.handleMovement(for: entityId, with: displacement)
        return nil
    }
}
