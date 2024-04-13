//
//  RemoteRemoveEvent.swift
//  TowerForge
//
//  Created by Zheng Ze on 12/4/24.
//

import Foundation

class RemoteRemoveEvent: TFRemoteEvent {
    let type: String
    let timeStamp: TimeInterval
    let source: UserPlayerId

    let id: UUID

    init(id: UUID, player: GamePlayer) {
        self.type = String(describing: RemoteRemoveEvent.self)
        self.timeStamp = Date().timeIntervalSince1970
        self.source = player.userPlayerId

        self.id = id
    }

    func unpack(into eventManager: EventManager, for gamePlayer: UserPlayerId) {
        let removeEvent = RemoveEvent(on: id, at: timeStamp)
        eventManager.add(removeEvent)
    }
}
