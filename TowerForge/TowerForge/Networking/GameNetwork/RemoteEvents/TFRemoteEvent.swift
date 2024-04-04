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
    var shouldSourceExecute: Bool { get set }

    func unpack(into eventManager: EventManager)
}
