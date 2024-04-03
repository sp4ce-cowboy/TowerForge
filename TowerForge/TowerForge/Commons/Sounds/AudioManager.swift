import Foundation
import AVFoundation

/// Explicit internal class to ensure that external clients cannot
/// interfere with singleton instance. Singleton anti-pattern used here
/// in line with Apple's AVAudioSession sharedInstance.
///
/// Credits (All music used is free for non-commercial use)
/// - Level Background Music: Entering The Stronghold by [Denny Schneidemesser](https://www.autodidactic.ai/music/)
/// - Game Background Music: Field of Memories by [WaterFlame](https://www.waterflame.com/contact-info)
/// - Sound Effect credits: [Pixabay](https://pixabay.com/service/license-summary/)
internal class AudioManager: NSObject, AVAudioPlayerDelegate {
    internal static let shared = AudioManager() // Singleton instance
    private var backgroundAudioPlayer: AVAudioPlayer?
    private var mainAudioPlayer: AVAudioPlayer?

    private var soundEffectPlayers: [String: AVAudioPlayer] = [:] // Cache sound effect players
    private var isBackgroundPlaying = false
    private var isMainPlaying = false

    private let SOUND_EFFECTS_ENABLED = Constants.SOUND_EFFECTS_ENABLED
    private let VOLUME = Constants.SOUND_EFFECTS_VOLUME

    override init() {
        super.init()
        setupAllAudioPlayers()
        backgroundAudioPlayer?.prepareToPlay()
        Logger.log("AudioManager is initialized", self)
    }

    func setupAllAudioPlayers() {
        setupGameAudioPlayer()
        setupMainAudioPlayer()
    }

    func setupGameAudioPlayer() {
        let soundName = Constants.GAME_BACKGROUND_AUDIO

        guard let soundURL = Bundle.main.url(forResource: soundName,
                                             withExtension: nil) else {
            Logger.log("Sound effect \(soundName) not found", self)
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            backgroundAudioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            backgroundAudioPlayer?.delegate = self
            backgroundAudioPlayer?.numberOfLoops = -1 // Loop indefinitely
            backgroundAudioPlayer?.volume = VOLUME
            backgroundAudioPlayer?.prepareToPlay()
        } catch {
            Logger.log("Failed to play sound effect \(soundName): \(error)", self)
        }
    }

    func setupMainAudioPlayer() {
        let soundName = Constants.MAIN_BACKGROUND_AUDIO

        guard let soundURL = Bundle.main.url(forResource: soundName,
                                             withExtension: nil) else {
            Logger.log("Sound effect \(soundName) not found", self)
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            mainAudioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            mainAudioPlayer?.delegate = self
            mainAudioPlayer?.numberOfLoops = -1 // Loop indefinitely
            mainAudioPlayer?.volume = VOLUME
            mainAudioPlayer?.prepareToPlay()
        } catch {
            Logger.log("Failed to play sound effect \(soundName): \(error)", self)
        }
    }

    /// Plays background music
    func playMainMusic() {
        stopBackground()
        if !isMainPlaying {
            mainAudioPlayer?.play()
            isMainPlaying = true
        }
    }

    /// Pauses background music
    func pauseMainMusic() {
        if isMainPlaying {
            mainAudioPlayer?.pause()
            isMainPlaying = false
        }
    }

    /// Stops background music and resets the time
    func stopMainMusic() {
        mainAudioPlayer?.stop()
        mainAudioPlayer?.currentTime = 0
        isMainPlaying = false
    }

    /// Plays background music
    func playBackground() {
        stopMainMusic()
        if !isBackgroundPlaying {
            backgroundAudioPlayer?.play()
            isBackgroundPlaying = true
        }
    }

    /// Pauses background music
    func pauseBackground() {
        if isBackgroundPlaying {
            backgroundAudioPlayer?.pause()
            isBackgroundPlaying = false
        }
    }

    /// Stops background music and resets the time
    func stopBackground() {
        backgroundAudioPlayer?.stop()
        backgroundAudioPlayer?.currentTime = 0
        isBackgroundPlaying = false
    }

    /// Mutes background music
    func muteBackground() {
        backgroundAudioPlayer?.volume = 0
    }

    /// Unmutes background music
    func unmuteBackground() {
        backgroundAudioPlayer?.volume = VOLUME
    }

    /// Toggle play/pause background music
    func toggleBackground() {
        if isBackgroundPlaying {
            self.pauseBackground()
        } else {
            self.playBackground()
        }
    }

    /// Toggle play/pause main music
    func toggleMain() {
        if isMainPlaying {
            self.pauseMainMusic()
        } else {
            self.playMainMusic()
        }
    }

    // --- Sound effects --- //

    /// Play a sound effect
    func playSoundEffect(for soundNameEnumCase: SoundEffect) {
        var soundName = soundNameEnumCase.rawValue
        guard SOUND_EFFECTS_ENABLED else {
            return
        }
        // Attempt to use a cached player if available
        if let player = soundEffectPlayers[soundName] {
            player.play()
        } else {
            // Create a new player for the sound effect
            guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: nil) else {
                Logger.log("Sound effect \(soundName) not found", self)
                return
            }
            do {
                let player = try AVAudioPlayer(contentsOf: soundURL)
                player.volume = 1.0
                player.prepareToPlay()
                player.play()
                soundEffectPlayers[soundName] = player
            } catch {
                Logger.log("Failed to play sound effect \(soundName): \(error)", self)
            }
        }
    }

    var soundEffectMap: [SoundEffect: () -> Void] {
        [
            .beep: { self.playSoundEffect(for: .beep) },
            .hit: { self.playSoundEffect(for: .hit) },
            .special: { self.playSoundEffect(for: .special) },
            .lose: { self.playSoundEffect(for: .lose) },
            .win: { self.playSoundEffect(for: .win) }
        ]
    }

    func playWinSoundEffect() {
        soundEffectMap[.win]?()
    }

    func playLoseSoundEffect() {
        soundEffectMap[.lose]?()
    }

    func playHitEffect() {
        soundEffectMap[.hit]?()
    }

    func playSpecialEffect() {
        soundEffectMap[.special]?()
    }

    func playBeepEffect() {
        soundEffectMap[.beep]?()
    }

}
