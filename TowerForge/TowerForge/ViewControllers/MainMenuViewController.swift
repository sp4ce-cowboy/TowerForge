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
}
