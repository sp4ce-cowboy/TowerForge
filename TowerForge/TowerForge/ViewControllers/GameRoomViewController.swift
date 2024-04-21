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
    @IBOutlet private var RoomNameInput: UITextField!
    @IBOutlet private var PlayerNameInput: UITextField!

    var gameRoom: GameRoom?
    var currentPlayer: GamePlayer?
    let firebaseRepository = FirebaseRepository()

    @IBAction private func createRoomButtonPressed(_ sender: Any) {
        guard let roomName = RoomNameInput.text, !roomName.isEmpty,
            let playerName = PlayerNameInput.text, !playerName.isEmpty else {
            // Show an alert or some indication to the user that inputs are empty
            return
        }

        let playerOne = GamePlayer(userName: playerName)
        gameRoom = GameRoom(roomName: roomName) { success in
            if success {
                Logger.log("Now joining the room \(success)", self)
                self.joinRoom(player: playerOne)
            } else {
                self.gameRoom = nil
            }
        }
    }

    func joinRoom(player: GamePlayer) {
        // Create a game room
        gameRoom?.joinRoom(player: player, completion: { success in
            if success {
                Logger.log("Successfully joined the room", self)
                self.currentPlayer = player
                self.performSegue(withIdentifier: "segueToWaitingRoom", sender: self)
            } else {
                Logger.log("Failed to join room", self)
            }
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToWaitingRoom" {
            if let destinationVC = segue.destination as? GameWaitingRoomViewController {
                guard let currentPlayer = self.currentPlayer else {
                    return
                }
                Logger.log("Before segueing \(String(describing: gameRoom?.playerOne))", self)
                destinationVC.currentPlayer = currentPlayer
                destinationVC.gameRoom = gameRoom
            }
        }
    }

    @IBAction private func joinRoomButtonPressed(_ sender: Any) {
        guard let roomName = RoomNameInput.text, !roomName.isEmpty,
            let playerName = PlayerNameInput.text, !playerName.isEmpty else {
            // Show an alert or some indication to the user that inputs are empty
            return
        }
        let player = GamePlayer(userName: playerName)
        GameRoom.findRoomWithName(roomName) { room in
            if let room = room {
                self.gameRoom = room
                self.joinRoom(player: player)
            } else {
                Logger.log("Room not found", self)
            }
        }
    }
}
