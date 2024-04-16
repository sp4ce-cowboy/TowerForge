//
//  RemoteConcedeEvent.swift
//  TowerForge
//
//  Created by Zheng Ze on 16/4/24.
//

import Foundation

class RemoteConcedeEvent: TFRemoteEvent {
    let type: String
    let timeStamp: TimeInterval
    let source: UserPlayerId

    let targetIsSource: Bool

    init(source: UserPlayerId, targetIsSource: Bool) {
        self.type = String(describing: RemoteConcedeEvent.self)
        self.timeStamp = Date().timeIntervalSince1970
        self.source = source
        self.targetIsSource = targetIsSource
    }

    func unpack(into eventManager: EventManager, for gamePlayer: UserPlayerId) {
        let player: Player = (gamePlayer == source) == targetIsSource ? .ownPlayer : .oppositePlayer
        let concedeEvent = ConcedeEvent(timestamp: timeStamp, player: player)
        eventManager.add(concedeEvent)
    }
}
