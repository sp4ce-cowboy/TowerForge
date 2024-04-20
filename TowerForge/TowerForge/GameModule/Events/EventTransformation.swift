//
//  EventTransformation.swift
//  TowerForge
//
//  Created by Keith Gan on 31/3/24.
//

import Foundation

protocol EventTransformation: Identifiable, AnyObject {
    static var DURATION: CGFloat { get } // Max duration
    var id: UUID { get }
    init(player: Player, id: UUID)
    func transformEvent(event: TFEvent) -> TFEvent
}
