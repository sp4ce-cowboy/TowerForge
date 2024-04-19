//
//  GamePlayer.swift
//  TowerForge
//
//  Created by Vanessa Mae on 02/04/24.
//

import Foundation

class GamePlayer: Codable {
    static let defaultPlayer = GamePlayer(userPlayerId: "", userName: "")
    var userPlayerId: UserPlayerId
    let userName: String

    init(userPlayerId: UserPlayerId = UUID().uuidString, userName: String) {
        self.userName = userName
        self.userPlayerId = userPlayerId
    }
}

extension GamePlayer: Equatable {
    static func == (lhs: GamePlayer, rhs: GamePlayer) -> Bool {
        lhs.userPlayerId == rhs.userPlayerId
    }
}
