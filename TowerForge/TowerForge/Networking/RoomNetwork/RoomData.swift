//
//  RoomData.swift
//  TowerForge
//
//  Created by Vanessa Mae on 03/04/24.
//

import Foundation

enum RoomState: Codable {
    case empty
    case waitingForPlayers
    case disconnected
    case gameEnded
    case gameOnGoing
}

struct RoomData: Codable {
    let roomName: String
    let roomState: RoomState?
}
