import Foundation
import UIKit

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

struct PositionConstants {
    // Death Match Mode Properties Positions
    static let DEATH_MATCH_POINT_OWN = CGPoint(x: 300, y: 50)
    static let DEATH_MATCH_POINT_OPP = CGPoint(x: 300, y: 110)

    // Capture the Flag Mode Properties
    static let CTF_POINT_OWN = CGPoint(x: 300, y: 50)
    static let CTF_POINT_OPP = CGPoint(x: 300, y: 110)

    // Survival Mode Properties
    static let SURVIVAL_POINT_OWN = CGPoint(x: 300, y: 100)

    static let SUBTITLE_LABEL_OFFSET = CGPoint(x: 0, y: -30)
}

struct SizeConstants {

    // Death Match Mode Properties Size
    static let DEATH_MATCH_POINT_SIZE = CGSize(width: 50, height: 50)

    // Capture the Flag Mode Properties Size
    static let CTF_POINT_SIZE = CGSize(width: 50, height: 50)

    // Survival Mode Properties Size
    static let SURVIVAL_POINT_SIZE = CGSize(width: 100, height: 100)

    static let SCREEN_SIZE = CGSize(width: UIScreen.main.bounds.width,
                                    height: UIScreen.main.bounds.height)
}

struct FontConstants {
    static let GAME_FONT_SIZE: CGFloat = 40.0
}

struct GameModeSettingsConstants {
    // Survival Mode Settings

}
