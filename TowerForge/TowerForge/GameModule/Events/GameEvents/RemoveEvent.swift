import Foundation

struct RemoveEvent: TFEvent {
    let timestamp: TimeInterval
    let entityId: UUID

    init(on entityId: UUID, at timestamp: TimeInterval) {
        self.timestamp = timestamp
        self.entityId = entityId
    }

    func execute(in target: any EventTarget) -> EventOutput {
        if let removeSystem = target.system(ofType: RemoveSystem.self) {
            removeSystem.handleRemove(for: entityId)
        }
        return EventOutput()
    }
}
