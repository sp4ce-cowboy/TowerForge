//
//  EventTransformation.swift
//  TowerForge
//
//  Created by Keith Gan on 31/3/24.
//

import Foundation

protocol EventTransformation: Identifiable {
    var id: UUID { get}
    func transformEvent(event: TFEvent) -> TFEvent
}
