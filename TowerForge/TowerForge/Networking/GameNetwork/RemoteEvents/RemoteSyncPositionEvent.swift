//
//  RemoteMoveEvent.swift
//  TowerForge
//
//  Created by Zheng Ze on 12/4/24.
//

import Foundation

class RemoteSyncPositionEvent: TFRemoteEvent {
    let type: String
    let timeStamp: TimeInterval
    let source: UserPlayerId

    let positionMap: [UUID: CGPoint]

    init(positionMap: [UUID: CGPoint], gamePlayer: GamePlayer) {
        self.type = String(describing: RemoteSyncPositionEvent.self)
        self.timeStamp = Date().timeIntervalSince1970
        self.source = gamePlayer.userPlayerId

        self.positionMap = positionMap
    }

    func unpack(into eventManager: EventManager, for gamePlayer: UserPlayerId) {
        if gamePlayer == source {
            return
        }

        positionMap.forEach({ id, position in
            let translatedPosition = CGPoint(x: GameWorld.worldSize.width - position.x, y: position.y)
            let event = UpdatePostionEvent(at: timeStamp, entityId: id, position: translatedPosition)
            eventManager.add(event)
        })
    }
}
