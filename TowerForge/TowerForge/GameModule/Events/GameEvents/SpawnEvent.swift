import Foundation

struct SpawnEvent: TFEvent {
    let timestamp: TimeInterval
    let entityId: UUID
    let entity: TFEntity

    init<T: TFEntity & RemoteSpawnable>(ofType type: T.Type, timestamp: TimeInterval,
                                        position: CGPoint, player: Player, id: UUID) {
        self.entity = type.init(position: position, player: player, id: id)
        self.timestamp = timestamp
        self.entityId = entity.id
    }

    init<T: TFEntity & Spawnable>(ofType type: T.Type, timestamp: TimeInterval, position: CGPoint, player: Player) {
        self.entity = type.init(position: position, player: player)
        self.timestamp = timestamp
        self.entityId = entity.id
    }

    func execute(in target: any EventTarget) -> EventOutput {
        if let spawnSystem = target.system(ofType: SpawnSystem.self) {
            spawnSystem.handleSpawn(with: entity)
        }
        return EventOutput()
    }
}
