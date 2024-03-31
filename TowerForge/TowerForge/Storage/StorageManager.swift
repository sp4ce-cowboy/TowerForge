//
//  Storage.swift
//  TowerForge
//
//  Created by Rubesh on 27/3/24.
//

import Foundation

/// The Storage Architecture of TowerForge consists of a few layers. From highest
/// to lowest, these are:
/// - StorageManager: Application wide access to data persistence
/// - Storage: A collection of a specific type of items that can be written to data
/// - Storable: The lowest level of, represents a single unit of an item that can be stored.
///
/// This allows for a nuanced, sequential and hierarchial approach to data persistence,
/// within a monolithic Storage Architecture, and thus, without having to fragment
/// Storage across TowerForge.
///
/// Hypothetical Example: local copy of the TowerForge application may contain information
/// such as a list of Achievements and a list of user preferences. This would translate
/// to a "AchievementStorage: Storage" class and "UserPrefStorage: Storage" class being
/// stored within the StorageManager and loaded upon every launch of the application.
/// "Achievement: Storable" would be stored inside AchievementStorage and "UserPreferenece: Storable"
/// would be stored within the UserPrefStorage.
///
/// A singular, universal StorageManager that allows for simultaneously storing and isolating
/// storable items of different types.
typealias StorageType = StorageEnums.StorageType
class StorageManager {
    static let folderName = Constants.STORAGE_CONTAINER_NAME
    static var shared = StorageManager() // Singleton instance
    var storedData: [StorageType: any Storage] = [:]

}
