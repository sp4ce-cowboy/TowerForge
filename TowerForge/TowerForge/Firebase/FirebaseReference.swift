//
//  FirebaseReference.swift
//  TowerForge
//
//  Created by Vanessa Mae on 02/04/24.
//

import Foundation
#if canImport(FirebaseDatabase)
import FirebaseDatabase
#endif

enum FirebaseReference: String {
    case Game
    case Rooms
    case Players
    case Ranks
    case Statistics
    case Metadata
}

#if canImport(FirebaseDatabase)
func FirebaseDatabaseReference(_ reference: FirebaseReference) -> DatabaseReference {

    Database.database(url: Constants.DATABASE_URL)
        .reference()
        .child(reference.rawValue)
}
#endif
