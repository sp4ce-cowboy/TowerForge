//
//  FirebaseRemoteEventPublisher.swift
//  TowerForge
//
//  Created by Zheng Ze on 4/4/24.
//

import Foundation
import FirebaseDatabase

class FirebaseRemoteEventPublisher: TFRemoteEventPublisher {
    private let gameReference: DatabaseReference

    init(roomId: RoomId) {
        self.gameReference = FirebaseDatabaseReference(.Game).child(roomId)
    }

    func publish(remoteEvent: any TFRemoteEvent) {
        gameReference.childByAutoId().setValue(TFNetworkCoder.toJsonString(event: remoteEvent))
    }
}
