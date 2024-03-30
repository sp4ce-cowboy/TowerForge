//
//  MainMenuViewController.swift
//  TowerForge
//
//  Created by Zheng Ze on 20/3/24.
//

import Foundation
import UIKit

class MainMenuViewController: UIViewController {
    var selectedGameMode: Mode = .deathMatch

    @IBAction private func DeathMatch(_ sender: Any) {
        selectedGameMode = .deathMatch
        performSegue(withIdentifier: "segueToGame", sender: self)
    }

    @IBAction private func CapturePressed(_ sender: Any) {
        selectedGameMode = .captureTheFlag
        performSegue(withIdentifier: "segueToGame", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToGame" {
            if let destinationVC = segue.destination as? GameViewController {
                destinationVC.gameMode = selectedGameMode
            }
        }
    }
}
