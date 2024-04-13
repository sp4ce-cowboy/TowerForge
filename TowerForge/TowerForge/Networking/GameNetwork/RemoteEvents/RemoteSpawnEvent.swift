//
//  RemoteSpawnEvent.swift
//  TowerForge
//
//  Created by Zheng Ze on 4/4/24.
//

import UIKit

class RemoteSpawnEvent: TFRemoteEvent {
    let type: String
    let timeStamp: TimeInterval
    let source: UserPlayerId

    let spawnType: String
    let spawnLocation: CGPoint
    let id: UUID

    init<T: TFEntity & RemoteSpawnable>(ofType type: T.Type, location: CGPoint, player: GamePlayer) {
        self.type = String(describing: RemoteSpawnEvent.self)
        self.timeStamp = Date().timeIntervalSince1970
        self.source = player.userPlayerId

        self.spawnType = String(describing: type)
        self.spawnLocation = location
        self.id = UUID()
    }

    func unpack(into eventManager: EventManager, for gamePlayer: UserPlayerId) {
        guard let type = Bundle.main.classNamed("TowerForge.\(spawnType)") as? (TFEntity & RemoteSpawnable).Type else {
            return
        }
        let player: Player = gamePlayer == source ? .ownPlayer : .oppositePlayer
        var position = spawnLocation
        if player == .oppositePlayer {
            position = CGPoint(x: GameWorld.worldSize.width - spawnLocation.x, y: spawnLocation.y)
        }
        let event = SpawnEvent(ofType: type, timestamp: timeStamp, position: position, player: player, id: id)
        eventManager.add(event)
    }
}
