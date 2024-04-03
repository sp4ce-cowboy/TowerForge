//
//  GameRoom.swift
//  TowerForge
//
//  Created by Vanessa Mae on 02/04/24.
//

import Foundation
import FirebaseDatabaseInternal

class GameRoom {
    private(set) var roomName: String
    private(set) var roomState: RoomState?

    private(set) var playerOne: GamePlayer?
    private(set) var playerTwo: GamePlayer?

    private(set) var firebaseRepository: FirebaseRepository?

    let roomRef = FirebaseDatabaseReference(.Rooms)

    var isRoomFull: Bool {
        playerOne != nil && playerTwo != nil
    }

    var gameRoomDelegate: GameRoomDelegate?

    var isRoomEmpty: Bool {
        playerOne == nil && playerTwo == nil
    }

    // the player creating the room will auto join the room
    init?(roomName: String,
          roomState: RoomState? = nil,
          repository: FirebaseRepository,
          completion: @escaping (Bool) -> Void) {
        self.roomName = roomName
        self.roomState = roomState
        self.firebaseRepository = repository

        // Check if the room name is available
        isRoomNameAvailable(roomName: roomName) { isAvailable in

            // If the room name is available, try to join the room
            guard isAvailable else {
                completion(false)
                return
            }

            self.postRoomDataToFirebase {  _, _ in
                self.makeRoomListener()
                completion(true)
            }
        }

    }
    init(roomName: String, roomState: RoomState? = nil) {
        self.roomName = roomName
        self.roomState = roomState
    }
    private func postRoomDataToFirebase(completion: ((_ err: Any?, _ result: String?) -> Void)?) {
        let roomRef = FirebaseDatabaseReference(.Rooms).child(roomName)
        roomRef.updateChildValues(["roomName": roomName as NSString? ]) { err, snap in
                if err != nil {
                    completion?(err, nil)
                } else {
                    completion?(nil, snap.key)
                }
        }
    }
    func joinRoom(player: GamePlayer, completion: @escaping (Bool) -> Void) {
        if isRoomFull {
            completion(false) // Room is full, cannot join
        } else {
            if playerOne == nil {
                playerOne = player
            } else {
                playerTwo = player
            }
            let playerRef = roomRef.child(roomName).child("players").childByAutoId()
            playerRef.setValue(player.userName)
            player.userPlayerId = playerRef.key
            completion(true) // Successfully joined the room
        }
    }
    func leaveRoom(player: GamePlayer, completion: @escaping (Bool) -> Void) {

        let roomPlayersRef = roomRef.child(roomName)

        roomPlayersRef.observeSingleEvent(of: .value) { snapshot  in

            if let playerData = snapshot.value as? [String: Any] {
                // Check if the leaving player is in the room
                if let playerKey = playerData.first(where: { $0.value as? String == player.userPlayerId })?.key {
                    // Remove the player from the room in the database
                    roomPlayersRef.child(playerKey).removeValue()

                    // Update local player data
                    if self.playerOne?.userPlayerId == player.userPlayerId {
                        self.playerOne = nil
                    } else if self.playerTwo?.userPlayerId == player.userPlayerId {
                        self.playerTwo = nil
                    }

                    completion(true) // Successfully left the room
                } else {
                    // The player is not in the room, cannot leave
                    completion(false)
                }
            } else {
                // No player data found in the room, cannot leave
                completion(false)
            }
        }
    }
    static func findRoomWithName(_ roomName: String, completion: @escaping (GameRoom?) -> Void) {
        let roomRef = FirebaseDatabaseReference(.Rooms).child(roomName)
        roomRef.getData { _, snapshot in
            if let snap = snapshot {
                if snap.exists() {
                    let room = GameRoom(roomName: roomName, roomState: .waitingForPlayers)
                    completion(room)
                } else {
                    completion(nil)
                }

            } else {
                completion(nil)
            }

        }
    }
    private func makeRoomListener() {
        roomRef.removeAllObservers()
        roomRef.child(roomName).observe(.value) { [weak self] _ in
            self?.gameRoomDelegate?.onRoomChange()
        }
    }
    private func isRoomNameAvailable(roomName: String, completion: @escaping (Bool) -> Void?) {
        FirebaseDatabaseReference(.Rooms).child(roomName).getData { _, snapshot in
            if let snap = snapshot {
                if snap.exists() {
                    completion(false)
                }
                completion(true)
            } else {
                completion(true)
            }
        }

    }
}
