//
//  TFContact.swift
//  TowerForge
//
//  Created by Zheng Ze on 22/3/24.
//

import Foundation

struct TFContact: Hashable {
    let entityIdA: UUID
    let entityIdB: UUID

    static func == (lhs: TFContact, rhs: TFContact) -> Bool {
        (lhs.entityIdA == rhs.entityIdA && lhs.entityIdB == rhs.entityIdB)
                || (lhs.entityIdA == rhs.entityIdB && lhs.entityIdB == rhs.entityIdA)
    }
}
