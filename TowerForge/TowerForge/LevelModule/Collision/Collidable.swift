//
//  Collidable.swift
//  TowerForge
//
//  Created by Zheng Ze on 22/3/24.
//

import Foundation

protocol Collidable {
    func collide(with other: Collidable) -> TFEvent
    func onSeparate()
    func collide(with damageComponent: DamageComponent) -> TFEvent
    func collide(with healthComponent: HealthComponent) -> TFEvent
    func collide(with movableComponent: MovableComponent) -> TFEvent
}
