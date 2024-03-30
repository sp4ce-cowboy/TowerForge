//
//  GameModeViewController.swift
//  TowerForge
//
//  Created by Vanessa Mae on 28/03/24.
//
import UIKit

class GameModeViewController: UIViewController {
    @IBOutlet private var deathMatchButton: UIButton!
    @IBOutlet var captureTheFlagButton: UIButton!
    var selectedGameMode = Mode.captureTheFlag

    @IBAction private func deathMatchButtonPressed(_ sender: UIButton) {
        selectedGameMode = .deathMatch
        navigateToGameViewController()
    }

    @IBAction private func captureTheFlagButtonPressed(_ sender: UIButton) {
        selectedGameMode = .captureTheFlag
        navigateToGameViewController()
    }

    private func navigateToGameViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let gameViewController = storyboard
                .instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else {
            return
        }
        gameViewController.gameMode = selectedGameMode
        print(selectedGameMode)
        present(gameViewController, animated: true, completion: nil)
    }
}
