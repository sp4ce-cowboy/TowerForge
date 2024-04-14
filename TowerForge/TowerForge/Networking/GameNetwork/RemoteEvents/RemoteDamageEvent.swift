//
//  RemoteDamageEvent.swift
//  TowerForge
//
//  Created by Zheng Ze on 12/4/24.
//

import Foundation

class RemoteDamageEvent: TFRemoteEvent {
    let type: String
    let timeStamp: TimeInterval
    let source: UserPlayerId

    let id: UUID
    let damage: CGFloat
    let targetIsSource: Bool

    init(id: UUID, damage: CGFloat, player: Player, gamePlayer: GamePlayer) {
        self.type = String(describing: RemoteDamageEvent.self)
        self.timeStamp = Date().timeIntervalSince1970
        self.source = gamePlayer.userPlayerId

        self.id = id
        self.damage = damage
        self.targetIsSource = player == .ownPlayer
    }

    func unpack(into eventManager: EventManager, for gamePlayer: UserPlayerId) {
        let player: Player = (gamePlayer == source) == targetIsSource ? .ownPlayer : .oppositePlayer
        let removeEvent = DamageEvent(on: id, at: timeStamp, with: damage, player: player)
        eventManager.add(removeEvent)
    }
}
