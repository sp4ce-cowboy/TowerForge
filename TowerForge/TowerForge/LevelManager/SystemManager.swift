//
//  SystemManager.swift
//  TowerForge
//
//  Created by Zheng Ze on 20/3/24.
//

import Foundation

class SystemManager {
    var systems: [String: TFSystem] = [:]
    func system<T: TFSystem>(ofType type: T.Type) -> T? {
        systems[String(describing: T.self)] as? T
    }

    func update(_ deltaTime: TimeInterval) {
        for system in systems.values where system.isActive {
            system.update(within: deltaTime)
        }
    }

    func add<T: TFSystem>(system: T) {
        guard systems[String(describing: T.self)] == nil else {
            return
        }
        systems[String(describing: T.self)] = system
    }

    func remove<T: TFSystem>(ofType type: T.Type) {
        systems.removeValue(forKey: String(describing: type.self))
    }
}
