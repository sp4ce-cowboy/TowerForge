import Foundation

struct SpawnEvent: TFEvent {
    let timestamp: TimeInterval
    let entityId: UUID

    private let position: CGPoint
    private let velocity: CGVector

    init(timestamp: TimeInterval, entityId: UUID, position: CGPoint, velocity: CGVector) {
        self.timestamp = timestamp
        self.entityId = entityId
        self.position = position
        self.velocity = velocity
    }

    func execute(in target: any EventTarget) -> EventOutput? {
        guard let spawnSystem = target.system(ofType: SpawnSystem.self) else {
            return nil
        }
        var entity = TFEntity()
        entity.addComponent(MovableComponent(position: position, velocity: velocity))
        spawnSystem.handleSpawn(with: entity)
        return EventOutput()
    }
}
