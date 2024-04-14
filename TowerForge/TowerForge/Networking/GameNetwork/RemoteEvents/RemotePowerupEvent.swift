//
//  RemotePowerupEvent.swift
//  TowerForge
//
//  Created by Zheng Ze on 12/4/24.
//

import Foundation

class RemotePowerupEvent: TFRemoteEvent {
    let type: String
    let timeStamp: TimeInterval
    let source: UserPlayerId

    let powerup: String
    let targetIsSource: Bool

    init(powerup: PowerUp, player: Player, source: GamePlayer) {
        self.type = String(describing: RemotePowerupEvent.self)
        self.timeStamp = Date().timeIntervalSince1970
        self.source = source.userPlayerId

        self.powerup = powerup.rawValue
        self.targetIsSource = player == .ownPlayer
    }

    func unpack(into eventManager: EventManager, for gamePlayer: UserPlayerId) {
        guard let type = Bundle.main.classNamed("TowerForge.\(powerup)PowerUp") as? any EventTransformation.Type else {
            return
        }
        let player: Player = (gamePlayer == source) == targetIsSource ? .ownPlayer : .oppositePlayer
//        let powerup = type.init(player: player)
//        eventManager.addTransformation(eventTransformation: powerup)
    }
}
