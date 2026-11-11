//
//  FirebaseRemoteEventPublisher.swift
//  TowerForge
//
//  Created by Zheng Ze on 4/4/24.
//
// Online-only: compiled when Firebase is linked (the App Store build is single-player).
#if canImport(FirebaseDatabase)

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
#endif
