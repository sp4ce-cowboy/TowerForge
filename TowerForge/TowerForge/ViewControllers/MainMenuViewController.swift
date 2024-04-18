//
//  MainMenuViewController.swift
//  TowerForge
//
//  Created by Zheng Ze on 20/3/24.
//

import Foundation
import UIKit

class MainMenuViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        AudioManager.shared.playMainMusic()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlayerStats" {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
            if let playerStatsVC = segue.destination as? PlayerStatsViewController {
                // Set any properties of playerStatsVC here
                // For example, pass an AchievementsDatabase instance if needed
            }
        }
    }

}
