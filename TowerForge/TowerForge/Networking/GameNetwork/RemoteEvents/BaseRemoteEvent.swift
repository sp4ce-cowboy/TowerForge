//
//  DisabledRemoteEvent.swift
//  TowerForge
//
//  Created by Zheng Ze on 4/4/24.
//

import Foundation

class BaseRemoteEvent: TFRemoteEvent {
    var type: String
    var timeStamp: TimeInterval
    var source: UserPlayerId

    init() {
        self.type = String(describing: BaseRemoteEvent.self)
        self.timeStamp = .zero
        self.source = ""
    }

    func unpack(into eventManager: EventManager, for gamePlayer: UserPlayerId) {}
}
