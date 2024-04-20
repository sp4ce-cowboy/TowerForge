//
//  EventTestsUtils.swift
//  TowerForgeTests
//
//  Created by Zheng Ze on 7/4/24.
//

import Foundation
@testable import TowerForge

class TestEvent: TFEvent {
    var timestamp = Date().timeIntervalSince1970
    var entityId = UUID()
    private(set) var didExecute = false

    func execute(in target: any TowerForge.EventTarget) -> TowerForge.EventOutput {
        didExecute = true
        return EventOutput()
    }
}

class TestRemoteEvent: TFRemoteEvent {
    var type = ""
    var timeStamp = Date().timeIntervalSince1970
    var source = ""
    private(set) var didUnpack = false

    func unpack(into eventManager: TowerForge.EventManager, for gamePlayer: TowerForge.UserPlayerId) {
        didUnpack = true
        eventManager.add(TestEvent())
    }
}

class TestEventTransformation: EventTransformation {
    static var DURATION = CGFloat(5)
    var id = UUID()
    private(set) var didTransformEvent = false

    required init(player: TowerForge.Player = .ownPlayer, id: UUID = UUID()) {}

    func transformEvent(event: any TowerForge.TFEvent) -> any TowerForge.TFEvent {
        didTransformEvent = true
        return event
    }
}

class TestEventTarget: EventTarget {
    var gameMode: GameMode = DeathMatchMode(eventManager: EventManager())

    func system<T: TFSystem>(ofType type: T.Type) -> T? {
        TestSystemA() as? T
    }
}
