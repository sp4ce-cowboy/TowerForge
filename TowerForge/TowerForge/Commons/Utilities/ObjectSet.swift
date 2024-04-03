//
//  ObjectSet.swift
//  TowerForge
//
//  Created by Rubesh on 31/3/24.
//

import Foundation

/// The ObjectSet utility class represents a compromise between reducing the cyclomatic
/// complexity of enums by replacing enums with dictionaries, and increasing code safety
/// by using enums to limit input values.
///
/// Essentially, as opposed to having an enum that violates the open-closed principle when
/// new objects are to be added, a dictionary is used instead. However, instead of having Strings
/// as keys, a specially defined hashable enum (i.e. rawRepresentable is String) is used to ensure
/// that arbitrary values cannot be used.
///
/// The typical use case is a static dictionary whose keys are of the same type as the aforementioned
/// enums. The value is a closure that takes in a certain set of arguments and outputs an object that
/// is needed. For example, is the fullStorableCreation below, the key is a TFStorableType which is an
/// enum that has "registered" storable types, such as case .killAchievement. The value corresponding to
/// this is a closure that takes in a UUID, a TFStorableType, a Double and outputs a KillAchievement.
/// The benefit of this approach is that manual switch-cases can be entirely elimated (thus OCP not violated),
/// by simply calling the appropriate closure with the required key, while still maintaining
/// runtime uniqueness without the type erasure that would occur if a generic Storable initializer were to
/// be called.
class ObjectSet {

    /// A dictionary of available Achievement types and closures that create full instances of them
    static var fullStorableCreation: [TFStorableType: (UUID, TFStorableType, Double) -> any Storable] = [
        .totalKillsAchievement: { id, type, value in TotalKillsAchievement(id: id, name: type, value: value) },
        .totalGamesAchievement: { id, type, value in TotalGamesAchievement(id: id, name: type, value: value) }
    ]

    static var fullStorageCreation: [TFStorageType: (Storage) -> Storage] = [
        .achievementStorage: { storage in AchievementStorage(objects: storage.storedObjects) }
    ]

    static var defaultAchievementCreation: [TFAchievementType: () -> any Achievement] = [
        .totalKillsAchievement: { TotalKillsAchievement() },
        .totalGamesAchievement: { TotalGamesAchievement() }
    ]

}
