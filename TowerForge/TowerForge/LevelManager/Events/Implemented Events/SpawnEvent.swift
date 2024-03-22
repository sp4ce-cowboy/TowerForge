import Foundation

struct SpawnEvent: TFEvent {
    let timestamp: TimeInterval
    let entityId: UUID
    let entity: TFEntity

    init<T: TFEntity & Spawnable>(ofType type: T.Type, timestamp: TimeInterval, position: CGPoint, team: Team) {
        self.entity = type.init(position: position, team: team)
        self.timestamp = timestamp
        self.entityId = entity.id
    }

    func execute(in target: any EventTarget) -> EventOutput? {
        guard let spawnSystem = target.system(ofType: SpawnSystem.self) else {
            return nil
        }
        spawnSystem.handleSpawn(with: entity)
        return EventOutput()
    }
}
