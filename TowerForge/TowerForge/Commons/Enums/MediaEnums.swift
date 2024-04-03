//
//  MediaEnums.swift
//  TowerForge
//
//  Created by Rubesh on 4/4/24.
//

import Foundation

typealias SoundEffect = MediaEnums.SoundEffect
typealias BackgroundMusic = MediaEnums.BackgroundMusic
class MediaEnums {

    /// An Enum where a case represents the type of the sound effect
    /// to be played and the RawValue represents the audio track file name
    /// associated with that sound effect.
    enum SoundEffect: String, CaseIterable {
        case win = "success.mp3"
        case lose = "lose.mp3"
        case hit = "hit-sound.mp3"
        case special = "jump.mp3"
        case beep = "beep.mp3"
    }

    /// An Enum where a case represents a certain type of background music
    /// and its RawValue represents the audio track file name associated with
    /// that sound effect.
    enum BackgroundMusic: String, CaseIterable {
        case main = "field-of-memories-soundtrack.mp3"
        case gameMode = "Entering-the-stronghold.mp3"
    }
}
