//
//  FirebaseReference.swift
//  TowerForge
//
//  Created by Vanessa Mae on 02/04/24.
//

import Foundation
import FirebaseDatabase

enum FirebaseReference: String {
    case Game
    case Rooms
    case Players
}

func FirebaseDatabaseReference(_ reference: FirebaseReference) -> DatabaseReference {

    Database.database(url: Constants.DATABASE_URL)
        .reference()
        .child(reference.rawValue)
}
