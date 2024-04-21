//
//  ConcedeEvent.swift
//  TowerForge
//
//  Created by Zheng Ze on 16/4/24.
//

import Foundation

class ConcedeEvent: TFEvent {
    var timestamp: TimeInterval
    var player: Player

    init(timestamp: TimeInterval, player: Player) {
        self.timestamp = timestamp
        self.player = player
    }

    func execute(in target: any EventTarget) -> EventOutput {
        target.gameMode.concede(player: player)
        return EventOutput()
    }
}
