//
//  RemoteMoveEvent.swift
//  TowerForge
//
//  Created by Zheng Ze on 12/4/24.
//

import Foundation

class RemoteMoveEvent: TFRemoteEvent {
    let type: String
    let timeStamp: TimeInterval
    let source: UserPlayerId

    let id: UUID
    let displacement: CGVector

    init(id: UUID, moveBy displacement: CGVector, gamePlayer: GamePlayer) {
        self.type = String(describing: RemoteMoveEvent.self)
        self.timeStamp = Date().timeIntervalSince1970
        self.source = gamePlayer.userPlayerId

        self.id = id
        self.displacement = displacement
    }

    func unpack(into eventManager: EventManager, for gamePlayer: UserPlayerId) {
        let displacement = displacement * (gamePlayer == source ? 1 : -1)
        let moveEvent = MoveEvent(on: id, at: timeStamp, with: displacement)
        eventManager.add(moveEvent)
    }
}
