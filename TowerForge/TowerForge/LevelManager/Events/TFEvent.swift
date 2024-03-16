//
//  TFEvent.swift
//  TowerForge
//
//  Created by Zheng Ze on 16/3/24.
//

import Foundation

protocol TFEvent {
    var timestamp: TimeInterval { get }
    var entityId: UUID { get }
    
    func execute(in target: EventTarget) -> EventOutput
}
