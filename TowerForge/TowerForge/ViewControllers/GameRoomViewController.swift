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

    @IBOutlet private var RoomNameInput: UITextField!

    @IBOutlet private var PlayerNameInput: UITextField!

    var gameRoom: GameRoom?
    let firebaseRepository = FirebaseRepository()

    @IBAction private func createRoomButtonPressed(_ sender: Any) {
        guard let roomName = RoomNameInput.text, !roomName.isEmpty,
            let playerName = PlayerNameInput.text, !playerName.isEmpty else {
            // Show an alert or some indication to the user that inputs are empty
            return
        }
        print("From user : \(roomName) and playername : \(playerName)")

        // Create a sample player for testing
        let playerOne = GamePlayer(userName: playerName)

        // Create a game room
        gameRoom = GameRoom(roomName: roomName,
                            repository: firebaseRepository) { success in
            if success {
                print("Room created successfully")
            } else {
                print("Failed to create room")
            }
        }
        gameRoom?.joinRoom(player: playerOne, completion: { success in
            if success {
               print("Successfully joined the room")
            }
        })
        performSegue(withIdentifier: "segueToWaitingRoom", sender: self)
    }
    @IBAction func joinRoomButtonPressed(_ sender: Any) {
        guard let roomName = RoomNameInput.text, !roomName.isEmpty,
            let playerName = PlayerNameInput.text, !playerName.isEmpty else {
            // Show an alert or some indication to the user that inputs are empty
            return
        }
        let room = GameRoom.findRoomWithName(roomName, repo: firebaseRepository)
        let player = GamePlayer(userName: playerName)
        room?.joinRoom(player: player, completion: { success in
            if success {
                print("Successfully joined the room")
            }
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToWaitingRoom" {
            if let destinationVC = segue.destination as? GameWaitingRoomViewController {
                destinationVC.gameRoom = gameRoom
            }
        }
    }
}
