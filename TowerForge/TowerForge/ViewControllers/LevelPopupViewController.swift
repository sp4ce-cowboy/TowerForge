//
//  LevelPopupViewController.swift
//  TowerForge
//
//  Created by MacBook Pro on 09/04/24.
//

import Foundation
import UIKit

protocol LevelPopupDelegate {
    func handleLevel(level: Int)
}

class LevelPopupViewController: UIViewController {

    var delegate: LevelPopupDelegate?

    @IBAction func onLevelOnePressed(_ sender: Any) {
        self.delegate?.handleLevel(level: 1)
        self.dismiss(animated: true)
    }
    @IBAction func onLevelTwoPressed(_ sender: Any) {
        self.delegate?.handleLevel(level: 2)
        self.dismiss(animated: true)
    }
    @IBAction func onLevelThreePressed(_ sender: Any) {
        self.delegate?.handleLevel(level: 3)
        self.dismiss(animated: true)
    }

    @IBAction func onClosePressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    static func showDialogBox(parentVC: UIViewController) {
        if let levelPopupViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "LevelPopupViewController")
            as? LevelPopupViewController {
            levelPopupViewController.modalTransitionStyle = .crossDissolve
            levelPopupViewController.modalPresentationStyle = .fullScreen
            levelPopupViewController.delegate = parentVC as? LevelPopupDelegate
            parentVC.present(levelPopupViewController, animated: true)
        }
    }
}
