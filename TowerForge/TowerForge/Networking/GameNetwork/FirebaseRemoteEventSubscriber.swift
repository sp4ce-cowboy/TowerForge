//
//  FirebaseRemoteEventSubscriber.swift
//  TowerForge
//
//  Created by Zheng Ze on 4/4/24.
//

import Foundation
import FirebaseDatabase

class FirebaseRemoteEventSubscriber: TFRemoteEventSubscriber {
    private let gameReference: DatabaseReference
    weak var eventManager: EventManager?

    init(roomId: RoomId, eventManager: EventManager? = nil) {
        self.eventManager = eventManager
        self.gameReference = FirebaseDatabaseReference(.Game).child(roomId)

        setUpObserver()
    }

    deinit {
        gameReference.removeAllObservers()
    }

    private func setUpObserver() {
        gameReference.observe(.childAdded) { snapshot in
            guard let string = snapshot.value as? String, let eventManager = self.eventManager,
                  let event = TFNetworkCoder.fromJsonString(string),
                  let player = eventManager.currentPlayer?.userPlayerId else {
                return
            }
            event.unpack(into: eventManager, for: player)
        }
    }
}
