//
//  GameRoom.swift
//  TowerForge
//
//  Created by Vanessa Mae on 02/04/24.
//

import Foundation

class GameRoom {
    private(set) var roomName: String
    private(set) var roomId: RoomId?
    private(set) var roomState: RoomState?

    private(set) var playerOne: GamePlayer?
    private(set) var playerTwo: GamePlayer?

    private(set) var firebaseRepository: FirebaseRepository

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
          roomCreator: GamePlayer,
          repository: FirebaseRepository,
          completion: @escaping (Bool) -> Void) {
        self.roomName = roomName
        self.roomState = roomState
        self.firebaseRepository = repository
        // Check if the room name is available
        isRoomNameAvailable(roomName: roomName) { [weak self] isAvailable in
            guard let self = self else { return }

            // If the room name is available, try to join the room
            guard isAvailable else {
                completion(false)
                return
            }

            self.joinRoom(player: roomCreator) { successful in
                // Check if joining the room was successful
                guard successful else {
                    completion(false) // Failed to join the room
                    return
                }
                do {
                    try self.postRoomDataToFirebase()
                } catch {
                    completion(false)
                }
                completion(true)
            }
        }

    }
    private func postRoomDataToFirebase() throws {
        let roomData = RoomData(roomName: roomName,
                                roomState: roomState)

        // Post room data to Firebase collection
        try firebaseRepository.postData(data: roomData, from: .Rooms)
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
            let playerDict: [String: Any] = [
                "userName": player.userName
            ]
            let playerRef = roomRef.child("players")
            playerRef.setValue(playerDict)
            completion(true) // Successfully joined the room
        }
    }
    func leaveRoom(player: GamePlayer, completion: @escaping (Bool) -> Void) {
        guard let roomId = roomId else {
            // Room ID is not set, unable to leave
            completion(false)
            return
        }

        let roomPlayersRef = roomRef.child(roomId)

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

    private func makeRoomListener() {
        roomRef.removeAllObservers()
        roomRef.observe(.value) { [weak self] snapshot in
            guard let dict = snapshot.value as? [String: Any?] else {
                return
            }
            self?.gameRoomDelegate?.onRoomChange()
        }
    }
    private func isRoomNameAvailable(roomName: String, completion: @escaping (Bool) -> Void?) {
        let ref = FirebaseDatabaseReference(.Rooms)
        ref.observeSingleEvent(of: .value) { snapshot  in
            if snapshot.exists() {
                if snapshot.hasChild(roomName) {
                    completion(false)
                } else {
                    completion(true)
                }
            } else {
                completion(true)
            }
        }
    }
}
