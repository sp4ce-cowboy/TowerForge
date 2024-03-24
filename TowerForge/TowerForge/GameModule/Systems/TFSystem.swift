import Foundation

/// Base protocol for all systems in TowerForge to conform to.
/// All systems must:
/// - contain information about their active status
/// - contain or reference and EntityManger
/// - contain or reference an EventManager
protocol TFSystem {
    var isActive: Bool { get set }
    var entityManager: EntityManager? { get set }
    var eventManager: EventManager? { get set }

    func update(within time: CGFloat)
}

/// This extension adds a default update implementation for a given system
extension TFSystem {
    func update(within time: CGFloat) { }
}

/// This extension adds the ability to modify the system's current activity state
extension TFSystem {
    mutating func activateSystem() {
        isActive = true
    }

    mutating func deactivateSystem() {
        isActive = false
    }

    mutating func toggleSystem() {
        isActive.toggle()
    }
}
