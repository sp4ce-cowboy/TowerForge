//
//  GameRoomViewController.swift
//  TowerForge
//
//  Created by Vanessa Mae on 03/04/24.
//

import Foundation
import UIKit

// Dummy still
class GameRoomViewController: UIViewController {
    @IBOutlet var MultiplayerButton: UIView!

    var gameRoom: GameRoom?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize Firebase repository
        let firebaseRepository = FirebaseRepository()

        // Create a sample player for testing
        guard let playerOne = GamePlayer(userName: "Player One", roomId: "2"),
              let playerTwo = GamePlayer(userName: "Player Twe", roomId: "2") else {
            return
        }

        // Create a game room
        gameRoom = GameRoom(roomName: "Room 1", roomCreator: playerOne, repository: firebaseRepository) { success in
            if success {
                print("Room created successfully")
            } else {
                print("Failed to create room")
            }
        }

        gameRoom?.joinRoom(player: playerTwo) { success in
            if success {
                print("Player Two joined the room")
            } else {
                print("Player Two failed to join the room")
            }
        }

        // Simulate leaving the room
        gameRoom?.leaveRoom(player: playerOne) { success in
            if success {
                print("Player One left the room")
            } else {
                print("Player One failed to leave the room")
            }
        }
    }
}
