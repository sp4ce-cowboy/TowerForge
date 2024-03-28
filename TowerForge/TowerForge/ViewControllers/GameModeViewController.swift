//
//  GameModeViewController.swift
//  TowerForge
//
//  Created by MacBook Pro on 28/03/24.
//
import UIKit

class GameModeViewController: UIViewController {
    @IBOutlet var deathMatchButton: UIButton!
    @IBOutlet var captureTheFlagButton: UIButton!
    var selectedGameMode = Mode.captureTheFlag

    @IBAction func deathMatchButtonPressed(_ sender: UIButton) {
            selectedGameMode = .deathMatch
            navigateToGameViewController()
        }

        @IBAction func captureTheFlagButtonPressed(_ sender: UIButton) {
            selectedGameMode = .captureTheFlag
            navigateToGameViewController()
        }

        private func navigateToGameViewController() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Assuming your storyboard name is "Main"
            guard let gameViewController = storyboard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else {
                return
            }
            gameViewController.gameMode = selectedGameMode
            present(gameViewController, animated: true, completion: nil)
        }
}
