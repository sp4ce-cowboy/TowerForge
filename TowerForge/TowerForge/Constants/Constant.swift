//
//  Constant.swift
//  TowerForge
//
//  Created by Vanessa Mae on 02/04/24.
//

import Foundation

struct DataConstants {
    static let playerTwoId = "playerTwoId"
    static let playerOneId = "playerOneId"
}

enum ErrorMessage: Error {
    case failedSnapshot, unknownError
}

typealias UserPlayerId = String
typealias RoomId = String
typealias GameId = String
