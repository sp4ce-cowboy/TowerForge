import Foundation
import AVFoundation

/// Explicit internal class to ensure that external clients cannot
/// interfere with singleton instance. Singleton anti-pattern used here
/// in line with Apple's AVAudioSession sharedInstance.
///
/// Credits
/// - Background Music: Field of Memories by [WaterFlame](https://www.waterflame.com/contact-info) (free for non-commercial use)
/// - Sound Effect credits: [Pixabay](https://pixabay.com/service/license-summary/)
internal class AudioManager: NSObject, AVAudioPlayerDelegate {
    internal static let shared = AudioManager() // Singleton instance
    private var backgroundAudioPlayer: AVAudioPlayer?
    private var soundEffectPlayers: [String: AVAudioPlayer] = [:] // Cache sound effect players
    private var isPlaying = false

    private let SOUND_EFFECTS_ENABLED = Constants.SOUND_EFFECTS_ENABLED
    private let VOLUME = Constants.SOUND_EFFECTS_VOLUME

    override init() {
        super.init()
        setupAudioPlayer()
        backgroundAudioPlayer?.prepareToPlay()
        Logger.log("AudioManager is initialized", self)
    }

    func setupAudioPlayer() {
        let soundName = Constants.BACKGROUND_AUDIO

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

    /// Plays background music
    func playBackground() {
        if !isPlaying {
            backgroundAudioPlayer?.play()
            isPlaying = true
        }
    }

    /// Pauses background music
    func pauseBackground() {
        if isPlaying {
            backgroundAudioPlayer?.pause()
            isPlaying = false
        }
    }

    /// Stops background music and resets the time
    func stopBackground() {
        backgroundAudioPlayer?.stop()
        backgroundAudioPlayer?.currentTime = 0
        isPlaying = false
    }

    /// Mutes background music
    func muteBackground() {
        backgroundAudioPlayer?.volume = 0
    }

    /// Unmutes background music
    func unmuteBackground() {
        backgroundAudioPlayer?.volume = VOLUME
    }

    // Toggle play/pause background music
    func toggle() {
        if isPlaying {
            self.pauseBackground()
        } else {
            self.playBackground()
        }
    }

    // Play a sound effect
    func playSoundEffect(named soundName: String) {
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

    func playWinSoundEffect() {
        playSoundEffect(named: "success.mp3")
    }

    func playLoseSoundEffect() {
        playSoundEffect(named: "lose.mp3")
    }

    func playHitEffect() {
        playSoundEffect(named: "hit-sound.mp3")
    }

    func playSpecialEffect() {
        playSoundEffect(named: "jump.mp3")
    }

    func playBeepEffect() {
        playSoundEffect(named: "beep.mp3")
    }
}
