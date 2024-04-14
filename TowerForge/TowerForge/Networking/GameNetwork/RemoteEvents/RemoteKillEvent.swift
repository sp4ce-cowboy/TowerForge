//
//  RemoteKillEvent.swift
//  TowerForge
//
//  Created by Zheng Ze on 12/4/24.
//

import Foundation

class RemoteKillEvent: TFRemoteEvent {
    let type: String
    let timeStamp: TimeInterval
    let source: UserPlayerId

    let id: UUID
    let targetIsSource: Bool

    init(id: UUID, player: Player, source: GamePlayer) {
        self.type = String(describing: RemoteKillEvent.self)
        self.timeStamp = Date().timeIntervalSince1970
        self.source = source.userPlayerId

        self.id = id
        self.targetIsSource = player == .ownPlayer
    }

    func unpack(into eventManager: EventManager, for gamePlayer: UserPlayerId) {
        let player: Player = (gamePlayer == source) == targetIsSource ? .ownPlayer : .oppositePlayer // XOR
        let killEvent = KillEvent(on: id, at: timeStamp, player: player)
        eventManager.add(killEvent)
    }
}
