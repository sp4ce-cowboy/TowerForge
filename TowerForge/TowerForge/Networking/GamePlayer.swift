//
//  GamePlayer.swift
//  TowerForge
//
//  Created by Vanessa Mae on 02/04/24.
//

import Foundation

class GamePlayer: Codable {
    var userPlayerId: UserPlayerId?
    let userName: String

    init(userName: String) {
        self.userName = userName
    }
}
