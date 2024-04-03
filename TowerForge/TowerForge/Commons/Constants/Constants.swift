import Foundation

/// A class to encapsulate application wide constants to ensure a single source of truth
/// across the entire application.
class Constants {

    /// Universally declaring logging
    static let LOGGING_IS_ACTIVE = true

    /// Firebase URL
    static let DATABASE_URL = "https://towerforge-d5ba7-default-rtdb.asia-southeast1.firebasedatabase.app"

    /// The name of the folder in which information is stored locally
    static let STORAGE_CONTAINER_NAME = "TowerForge"

    /// The name of the file that contains TowerForge data locally
    static let TF_DATABASE_NAME = "TowerForgeDatabase"

    /// Universal setting to enable or disable sound effects
    static var SOUND_EFFECTS_ENABLED = true

    /// Universal background audio soundtrack to play during game modes
    static let GAME_BACKGROUND_AUDIO: String = BackgroundMusic.gameMode.rawValue

    /// Universal background audio soundtrack to play during non-game modes
    static let MAIN_BACKGROUND_AUDIO: String = BackgroundMusic.main.rawValue

    /// Universal volume control for in-game volume elements
    static var SOUND_EFFECTS_VOLUME: Float = 0.8

}
