//
//  RoomData.swift
//  TowerForge
//
//  Created by Vanessa Mae on 03/04/24.
//

import Foundation

enum RoomState: String, Codable {
    case empty
    case waitingForMorePlayers
    case waitingForBothConfirmation
    case waitingForFinalConfirmation
    case disconnected
    case gameEnded
    case gameOnGoing
}

extension String {
    func toRoomState() -> RoomState? {
        RoomState(rawValue: self)
    }
}

extension RoomState {
    static func fromString(_ value: String) -> RoomState? {
        value.toRoomState()
    }
}

struct RoomData: Codable {
    let roomName: String
    let roomState: RoomState?
}
