//
//  GameProp.swift
//  TowerForge
//
//  Created by Vanessa Mae on 27/03/24.
//

import Foundation

protocol GameProp {
    associatedtype EntityType: TFEntity // Define an associated type constraint
    var renderableEntity: EntityType { get } // Use the associated type
}
