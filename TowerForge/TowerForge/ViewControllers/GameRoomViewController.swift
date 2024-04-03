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
    @IBOutlet private var MultiplayerButton: UIView!

    @IBOutlet private var CreateRoom: UIButton!
    @IBOutlet private var JoinRoom: UIButton!

    @IBOutlet private var RoomNameInput: UILabel!
    @IBOutlet private var PlayerNameInput: UILabel!

    var gameRoom: GameRoom?

    @IBAction private func createRoomButtonPressed(_ sender: Any) {
        guard let roomName = RoomNameInput.text, !roomName.isEmpty,
            let playerName = PlayerNameInput.text, !playerName.isEmpty else {
            // Show an alert or some indication to the user that inputs are empty
            return
        }

        performSegue(withIdentifier: "segueToWaitingRoom", sender: self)
    }
    @IBAction func joinRoomButtonPressed(_ sender: Any) {
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToWaitingRoom" {
            if let destinationVC = segue.destination as? GameWaitingRoomViewController {
                destinationVC.gameRoom = gameRoom
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize Firebase repository
        let firebaseRepository = FirebaseRepository()

        // Create a sample player for testing
        let playerOne = GamePlayer(userName: "PlayerOne")

        // Create a game room
        gameRoom = GameRoom(roomName: "Room1", roomCreator: playerOne, repository: firebaseRepository) { success in
            if success {
                print("Room created successfully")
            } else {
                print("Failed to create room")
            }
        }

//        gameRoom?.joinRoom(player: playerTwo) { success in
//            if success {
//                print("Player Two joined the room")
//            } else {
//                print("Player Two failed to join the room")
//            }
//        }
//
//        // Simulate leaving the room
//        gameRoom?.leaveRoom(player: playerOne) { success in
//            if success {
//                print("Player One left the room")
//            } else {
//                print("Player One failed to leave the room")
//            }
//        }
    }
}
