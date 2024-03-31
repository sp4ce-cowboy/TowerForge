//
//  Storable.swift
//  TowerForge
//
//  Created by Rubesh on 27/3/24.
//

import Foundation

protocol Storable: Codable {
    var id: UUID { get set }
    var name: String? { get set }
    var value: Double? { get set }
}
