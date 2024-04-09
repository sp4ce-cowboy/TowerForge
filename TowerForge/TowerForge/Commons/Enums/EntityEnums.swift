//
//  EntityEnums.swift
//  TowerForge
//
//  Created by Rubesh on 9/4/24.
//

import Foundation

typealias TFEntityType = EntityEnums.TFEntityType
typealias TFComponentType = EntityEnums.TFComponentType
class EntityEnums {
    
    enum TFEntityType: String, Codable, CaseIterable {
        case TFEntity
        case BaseTower
        case BaseUnit
        case BaseProjectile
        case Spawnable
        case MeleeUnit
        case SoldierUnit
        case ArrowTower
        case WizardUnit
        case Team
        case Bullet
        case Point
        case Life
        case Death
        case Timer
        case WizardBall
    }
    
    enum TFComponentType: String, Codable, CaseIterable {
        case TFComponent
        case PlayerComponent
        case AiComponent
        case HomeComponent
        case DamageComponent
        case HealthComponent
        case SpriteComponent
        case MovableComponent
        case PositionComponent
        case LabelComponent
        case ButtonComponent
        case TimerComponent
    }
}
