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
    private(set) var roomId: RoomId?
    private(set) var host: UserPlayerId?

    private(set) var playerOne: GamePlayer?
    private(set) var playerTwo: GamePlayer?

    private let roomRef = FirebaseDatabaseReference(.Rooms)

    var isRoomFull: Bool {
        playerOne != nil && playerTwo != nil
    }

    weak var gameRoomDelegate: GameRoomDelegate?

    var isRoomEmpty: Bool {
        playerOne == nil && playerTwo == nil
    }

    // the player creating the room will auto join the room
    init(roomName: String, roomState: RoomState? = nil, completion: @escaping (Bool) -> Void) {
        self.roomName = roomName
        self.roomState = roomState

        // Check if the room name is available
        isRoomNameAvailable(roomName: roomName) { isAvailable, id in
            // If the room name is available, try to join the room
            if isAvailable {
                self.roomId = id
                self.makeRoomChangeListener()
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    init(roomName: String, roomState: RoomState? = nil) {
        self.roomName = roomName
        self.roomState = roomState
        self.makeRoomChangeListener()
    }

    deinit {
        removeAllListeners()
    }

    private func postRoomDataToFirebase(completion: ((_ err: Any?, _ result: String?) -> Void)?) {
        let roomRef = FirebaseDatabaseReference(.Rooms).child(roomName)
        let roomId = UUID().uuidString
        self.roomState = .empty
        roomRef.updateChildValues(["roomId": roomId,
                                   "roomState": RoomState.empty.rawValue
                                  ]) { err, _ in
            if err != nil {
                completion?(err, nil)
            } else {
                completion?(nil, roomId)
            }
        }
    }

    func joinRoom(player: GamePlayer, completion: @escaping (Bool) -> Void) {
        let delegate = { (isFull: Bool) -> Void in
            if isFull {
                completion(false)
                return
            }
            if self.playerOne == nil {
                self.playerOne = player
            } else {
                self.playerTwo = player
            }

            let onAddCompleted = { (error: Error?, _: DatabaseReference) -> Void in
                if let error = error {
                    print("Error getting data: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                self.attemptSetHost(player: player)
                self.isRoomFull(self.roomName) { isFull in
                    if isFull {
                        self.updateRoomState(roomState: .waitingForBothConfirmation)
                    }
                    completion(true) // Successfully joined the room
                }
            }

            let playerRef = self.roomRef.child(self.roomName).child("players").child(player.userPlayerId)
            playerRef.setValue(player.userName, withCompletionBlock: onAddCompleted)
        }

        self.isRoomFull(roomName, completion: delegate)
    }

    // Logic to start the game when players are ready
    func updatePlayerReady(completion: @escaping (RoomState) -> Void) {
        print("Updating player start")
        if self.roomState == .waitingForFinalConfirmation {
            self.updateRoomState(roomState: .gameOnGoing)
            completion(.gameOnGoing)
        } else if self.roomState == .waitingForBothConfirmation {
            self.updateRoomState(roomState: .waitingForFinalConfirmation)
            completion(.waitingForFinalConfirmation)
        }
    }

    func deleteRoom() {
        guard roomState == .gameOnGoing else {
            return
        }
        roomRef.child(roomName).removeValue { error, _ in
            if let error = error {
                print("Error deleting room: \(error.localizedDescription)")
            } else {
                print("Room deleted successfully.")
            }
        }
    }

    // Updates the current room state in the class and database
    private func updateRoomState(roomState: RoomState) {
        print("Updating room state from player")
        let roomStateRef = FirebaseDatabaseReference(.Rooms).child(roomName).child("roomState")
        roomStateRef.setValue(roomState.rawValue) { error, _ in
            if let error = error {
                print("Error updating room state: \(error.localizedDescription)")
            } else {
                self.roomState = roomState
                print("Room state updated successfully.")
            }
        }
    }

    func leaveRoom(player: GamePlayer, completion: @escaping (Bool) -> Void) {
        let roomDataRef = roomRef.child(roomName)
        let delegate = { (snapshot: DataSnapshot) -> Void in
            let playerSnapshot = snapshot.childSnapshot(forPath: "players")
            let hostSnapshot = snapshot.childSnapshot(forPath: "host")
            guard let playerData = playerSnapshot.value as? [String: Any] else {
                completion(false)
                return
            }

            // Check if the leaving player is in the room
            guard let playerKey = playerData.first(where: { $0.key == player.userPlayerId })?.key else {
                // The player is not in the room, cannot leave
                completion(false)
                return
            }

            // Remove the player from the room in the database
            playerSnapshot.ref.child(playerKey).removeValue()

            guard playerData.count > 1 else {
                // Delete the room from the database
                roomDataRef.removeValue()
                completion(true) // Successfully left the room
                return
            }

            // Set other player as host if leaving player was host
            if let host = hostSnapshot.value as? String, host == player.userPlayerId,
               let otherPlayerId = playerData.first(where: { $0.key != player.userPlayerId })?.key {
                roomDataRef.updateChildValues(["host": otherPlayerId])
            }
            completion(true)
        }

        roomDataRef.observeSingleEvent(of: .value, with: delegate)
    }

    func getPlayerNum(gamePlayer: GamePlayer) -> Player? {
        if gamePlayer == playerOne {
            return .ownPlayer
        }
        if gamePlayer == playerTwo {
            return .oppositePlayer
        }
        return nil
    }

    private func isRoomFull(_ roomName: String, completion: @escaping (Bool) -> Void) {
        let playerRef = FirebaseDatabaseReference(.Rooms).child(roomName).child("players")
        playerRef.getData { error, snapshot in
            if let error = error {
                print("Error getting data: \(error.localizedDescription)")
                completion(false)
                return
            }

            // Need to access child snapshot here else it captures roomId and roomState and not just the childs
            guard let snap = snapshot?.childSnapshot(forPath: "players"), snap.exists() else {
                completion(false)
                return
            }

            let playerCount = snap.childrenCount
            completion(playerCount >= 2)
        }
    }

    static func findRoomWithName(_ roomName: String, completion: @escaping (GameRoom?) -> Void) {
        let roomRef = FirebaseDatabaseReference(.Rooms).child(roomName)
        roomRef.getData { _, snapshot in
            guard let snap = snapshot, snap.exists() else {
                completion(nil)
                return
            }

            guard let roomId = snap.childSnapshot(forPath: "roomId").value as? String,
                  let roomStateRawValue = snap.childSnapshot(forPath: "roomState").value as? String,
                  let roomState = RoomState.fromString(roomStateRawValue) else {
                completion(nil)
                return
            }

            let room = GameRoom(roomName: roomName, roomState: roomState)
            room.roomId = roomId
            completion(room)
        }
    }

    private func makeRoomChangeListener() {
        roomRef.child(roomName).observe(.value) { [weak self] snap in
            guard let snapshotValue = snap.value as? [String: Any] else {
                return
            }
            if let playersData = snapshotValue["players"] as? [String: Any] {
                self?.playerOne = nil
                self?.playerTwo = nil
                for (playerKey, playerData) in playersData {
                    guard let playerData = playerData as? String else {
                        continue
                    }
                    let player = GamePlayer(userPlayerId: playerKey, userName: playerData)
                    if self?.playerOne == nil {
                        self?.playerOne = player
                    } else if self?.playerTwo == nil && self?.playerOne != player {
                        self?.playerTwo = player
                    }
                }
            }
            if let roomStateData = snapshotValue["roomState"] as? String {
                self?.roomState = RoomState.fromString(roomStateData)
            }
            if let hostData = snapshotValue["host"] as? UserPlayerId {
                self?.host = hostData
            }
            self?.gameRoomDelegate?.onRoomChange()
        }
    }

    private func isRoomNameAvailable(roomName: String, completion: @escaping (Bool, String?) -> Void?) {
        FirebaseDatabaseReference(.Rooms).child(roomName).getData { _, snapshot in
            if let snap = snapshot {
                guard !snap.exists() else {
                    completion(false, nil)
                    return
                }
            }

            self.postRoomDataToFirebase { _, id in
                completion(true, id)
            }
        }

    }

    private func removeAllListeners() {
        roomRef.child(roomName).removeAllObservers()
    }

    private func attemptSetHost(player: GamePlayer) {
        let delegate = { (error: Error?, snapshot: DataSnapshot?) -> Void in
            if let error = error {
                print("Error getting data: \(error.localizedDescription)")
                return
            }

            guard let snap = snapshot, !snap.childSnapshot(forPath: "host").exists() else {
                return
            }

            snap.ref.updateChildValues(["host": player.userPlayerId])
        }
        FirebaseDatabaseReference(.Rooms).child(roomName).getData(completion: delegate)
    }
}
