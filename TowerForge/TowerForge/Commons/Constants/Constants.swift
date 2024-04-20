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
    static let LOCAL_STORAGE_CONTAINER_NAME = "TowerForge"

    /// The name of the TowerForge project to prefix
    static let PROJECT_NAME_PREFIX = "TowerForge"

    /// The name of the file that contains TowerForge data locally
    static let LOCAL_STORAGE_FILE_NAME = "TowerForgeLocalStorage.json"

    /// The name of the file that contains metadata about local storage
    static let METADATA_FILE_NAME = "TowerForgeMetadata.json"

    /// The name of the player currently logged in.
    /// By default, this is set to the default id associated with the device
    static var CURRENT_PLAYER_ID = ""

    /// The default id associated with the device
    static var CURRENT_DEVICE_ID = ""

    /// The universally declared conflict resolution method
    static var CONFLICT_RESOLTION: StorageConflictResolution = .MERGE

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
    private static let TOOLBAR_MID_Y = SizeConstants.TOOLBAR_HEIGHT / 2

    static let POINTS_OWN = CGPoint(x: 70 / SizeConstants.SCALE_RATIO, y: TOOLBAR_MID_Y)

    // Death Match Mode Properties Positions
    static let DEATH_MATCH_POINT_OWN = CGPoint(x: 270 / SizeConstants.SCALE_RATIO,
                                               y: TOOLBAR_MID_Y + SizeConstants.DEATH_MATCH_POINT_SIZE.height / 2 + 10)
    static let DEATH_MATCH_POINT_OPP = CGPoint(x: 270 / SizeConstants.SCALE_RATIO,
                                               y: TOOLBAR_MID_Y - SizeConstants.DEATH_MATCH_POINT_SIZE.height / 2 - 10)

    // Capture the Flag Mode Properties
    static let CTF_POINT_OWN = CGPoint(x: 270 / SizeConstants.SCALE_RATIO,
                                       y: TOOLBAR_MID_Y + SizeConstants.CTF_POINT_SIZE.height / 2 + 10)
    static let CTF_POINT_OPP = CGPoint(x: 270 / SizeConstants.SCALE_RATIO,
                                       y: TOOLBAR_MID_Y - SizeConstants.CTF_POINT_SIZE.height / 2 - 10)

    // Survival Mode Properties
    static let SURVIVAL_POINT_OWN = CGPoint(x: 270 / SizeConstants.SCALE_RATIO, y: TOOLBAR_MID_Y)

    // Unit Node
    static let UNIT_NODE_START = CGPoint(x: 450 / SizeConstants.SCALE_RATIO, y: TOOLBAR_MID_Y)

    static let SUBTITLE_LABEL_OFFSET = CGPoint(x: 0, y: -30 / SizeConstants.SCALE_RATIO)
}

struct SizeConstants {
    static let SCALE_RATIO = GameWorld.worldSize.height / UIScreen.main.bounds.height
    static let TOOLBAR_HEIGHT = UIScreen.main.bounds.height / 5

    static let POINT_SIZE = CGSize(width: 100 / SCALE_RATIO, height: 100 / SCALE_RATIO)

    // Death Match Mode Properties Size
    static let DEATH_MATCH_POINT_SIZE = CGSize(width: 50 / SCALE_RATIO, height: 50 / SCALE_RATIO)

    // Capture the Flag Mode Properties Size
    static let CTF_POINT_SIZE = CGSize(width: 50 / SCALE_RATIO, height: 50 / SCALE_RATIO)

    // Survival Mode Properties Size
    static let SURVIVAL_POINT_SIZE = CGSize(width: 80 / SCALE_RATIO, height: 80 / SCALE_RATIO)

    static let SCREEN_SIZE = CGSize(width: UIScreen.main.bounds.width,
                                    height: UIScreen.main.bounds.height)
}

struct FontConstants {
    static let GAME_FONT_SIZE: CGFloat = 40.0
}

struct GameModeSettingsConstants {
    // Survival Mode Settings

}
