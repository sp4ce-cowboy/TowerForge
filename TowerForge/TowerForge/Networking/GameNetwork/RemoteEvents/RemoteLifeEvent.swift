//
//  RemoteLifeEvent.swift
//  TowerForge
//
//  Created by Zheng Ze on 12/4/24.
//

import Foundation

class RemoteLifeEvent: TFRemoteEvent {
    let type: String
    let timeStamp: TimeInterval
    let source: UserPlayerId

    let reduceBy: Int
    let targetIsSource: Bool

    init(reduceBy: Int, player: Player, source: GamePlayer) {
        self.type = String(describing: RemoteLifeEvent.self)
        self.timeStamp = Date().timeIntervalSince1970
        self.source = source.userPlayerId

        self.reduceBy = reduceBy
        self.targetIsSource = player == .ownPlayer
    }

    func unpack(into eventManager: EventManager, for gamePlayer: UserPlayerId) {
        let player: Player = (gamePlayer == source) == targetIsSource ? .ownPlayer : .oppositePlayer
        let lifeEvent = LifeEvent(at: timeStamp, reduceBy: reduceBy, player: player)
        eventManager.add(lifeEvent)
    }
}
