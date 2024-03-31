//
//  EventTransformation.swift
//  TowerForge
//
//  Created by Keith Gan on 31/3/24.
//

protocol EventTransformation {
    func transformEvent(event: TFEvent) -> TFEvent
}
