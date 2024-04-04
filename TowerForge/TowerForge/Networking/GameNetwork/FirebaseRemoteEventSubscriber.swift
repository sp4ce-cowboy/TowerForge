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
    unowned let eventManager: EventManager

    init(eventManager: EventManager, roomId: RoomId) {
        self.eventManager = eventManager
        self.gameReference = FirebaseDatabaseReference(.Game).child(roomId)

        setUpObserver()
    }

    deinit {
        gameReference.removeAllObservers()
    }

    private func setUpObserver() {
        gameReference.observe(.childAdded) { snapshot, _  in
            guard let string = snapshot.value as? String, let event = TFNetworkCoder.fromJsonString(string) else {
                return
            }
            event.unpack(into: self.eventManager)
        }
    }
}
