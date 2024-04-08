//
//  GameModeViewController.swift
//  TowerForge
//
//  Created by Vanessa Mae on 28/03/24.
//
import UIKit

class GameModeViewController: UIViewController {
    @IBOutlet private var deathMatchButton: UIButton!
    @IBOutlet private var captureTheFlagButton: UIButton!
    @IBOutlet private var MultiplayerButton: UIButton!
    var selectedGameMode = Mode.captureTheFlag

    @IBAction private func deathMatchButtonPressed(_ sender: UIButton) {
        selectedGameMode = .deathMatch
        navigateToGameViewController()
    }

    @IBAction private func captureTheFlagButtonPressed(_ sender: UIButton) {
        selectedGameMode = .captureTheFlag
        navigateToGameViewController()
    }

    @IBAction func onLoginViewPressed(_ sender: Any) {
        performSegue(withIdentifier: "segueToLogin", sender: self)
    }
    @IBAction private func multiButtonPressed(_ sender: Any) {
        navigateToGameRoomViewController()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? GameViewController {
            destVC.gameMode = selectedGameMode
        }
    }

    private func navigateToGameRoomViewController() {
        performSegue(withIdentifier: "segueToGameRoom", sender: self)
    }

    private func navigateToGameViewController() {
        performSegue(withIdentifier: "segueToGame", sender: self)
    }
}
