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

    init?(userName: String, roomId: String) {
        self.userName = userName
        var isUserSetupSuccessful = false
        // Attempt to init the player in Firebase Realtime Database
        let ref = FirebaseDatabaseReference(.Rooms).child(roomId).child("players")
        let playerRef = ref.childByAutoId()
        playerRef.setValue(["name": userName]) { error, _ in
            if let error = error {
                // If storing fails, return nil
            } else {
                // If storing succeeds, set the generated userPlayerId
                self.userPlayerId = playerRef.key ?? ""
                if self.userPlayerId != "" {
                    isUserSetupSuccessful = true
                }
            }
        }
        if !isUserSetupSuccessful {
            return nil
        }
    }
}
