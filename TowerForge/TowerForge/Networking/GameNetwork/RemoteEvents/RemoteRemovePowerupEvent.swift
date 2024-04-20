//
//  RemoteRemovePowerupEvent.swift
//  TowerForge
//
//  Created by Zheng Ze on 19/4/24.
//

import Foundation

class RemoteRemovePowerupEvent: TFRemoteEvent {
    let type: String
    let timeStamp: TimeInterval
    let source: UserPlayerId

    let id: UUID

    init(id: UUID, source: GamePlayer) {
        self.type = String(describing: RemoteRemovePowerupEvent.self)
        self.timeStamp = Date().timeIntervalSince1970
        self.source = source.userPlayerId

        self.id = id
    }

    func unpack(into eventManager: EventManager, for gamePlayer: UserPlayerId) {
        eventManager.removeTransformation(with: id)
    }
}
