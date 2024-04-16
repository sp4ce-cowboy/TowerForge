//
//  ObjectSet.swift
//  TowerForge
//
//  Created by Rubesh on 31/3/24.
//

import Foundation

/// The ObjectSet utility class represents a compromise between reducing the cyclomatic
/// complexity of enums by replacing enums with dictionaries, and increasing code safety
/// by using hashable wrapped types to limit input values.
///
/// Essentially, as opposed to having an enum that violates the open-closed principle when
/// new objects are to be added, a dictionary is used instead. However, instead of having Strings
/// as keys, a specially defined hashable wrapped type is used to ensure that arbitrary values
/// cannot be used as keys.
///
/// This pattern is also applied across other Factory classes in TowerForge, according to specific
/// needs.
class ObjectSet {

    static let availableEventTypes: [TFEvent.Type] =
        [
            DamageEvent.self,
            MoveEvent.self,
            SpawnEvent.self,
            RemoveEvent.self,
            LifeEvent.self,
            KillEvent.self,
            DisabledEvent.self,
            RequestSpawnEvent.self,
            WaveSpawnEvent.self,
            GameStartEvent.self
        ]

}
