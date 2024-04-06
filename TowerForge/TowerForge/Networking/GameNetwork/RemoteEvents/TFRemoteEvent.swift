//
//  TFRemoteEvent.swift
//  TowerForge
//
//  Created by Zheng Ze on 4/4/24.
//

import Foundation

// An event that is to be propogated to other players.
protocol TFRemoteEvent: Codable {
    var type: String { get }
    var timeStamp: TimeInterval { get }
    var source: UserPlayerId { get }

    func unpack(into eventManager: EventManager, for gamePlayer: UserPlayerId)
}
