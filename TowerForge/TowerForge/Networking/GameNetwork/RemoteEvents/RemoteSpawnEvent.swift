//
//  RemoteSpawnEvent.swift
//  TowerForge
//
//  Created by Zheng Ze on 4/4/24.
//

import Foundation

class RemoteSpawnEvent: TFRemoteEvent {
    let type: String
    let timeStamp: TimeInterval
    let source: UserPlayerId
    var shouldSourceExecute: Bool

    let spawnType: String
    let spawnLocation: CGPoint
    let id: UUID

    init<T: TFEntity & RemoteSpawnable>(ofType type: T.Type, location: CGPoint, player: GamePlayer) {
        self.type = String(describing: RemoteSpawnEvent.self)
        self.timeStamp = Date().timeIntervalSince1970
        self.source = player.userPlayerId ?? ""
        self.shouldSourceExecute = true

        self.spawnType = String(describing: type)
        self.spawnLocation = location
        self.id = UUID()
    }

    func unpack(into eventManager: EventManager) {
        guard shouldSourceExecute,
              let type = Bundle.main.classNamed("TowerForge.\(spawnType)") as? (TFEntity & RemoteSpawnable).Type else {
            return
        }
        eventManager.add(SpawnEvent(ofType: type, timestamp: timeStamp,
                                    position: spawnLocation, player: .oppositePlayer, id: id))
    }
}
