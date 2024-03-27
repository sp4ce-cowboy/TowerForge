//
//  GameModeViewController.swift
//  TowerForge
//
//  Created by MacBook Pro on 28/03/24.
//
import UIKit

class GameModeViewController: UIViewController {
    var selectedGameMode = Mode.captureTheFlag

    override func viewDidLoad() {
        super.viewDidLoad()
        addButtons()
    }

    private func addButtons() {
        let buttonWidth: CGFloat = 200
        let buttonHeight: CGFloat = 100
        let _: CGFloat = 20

        // First button: Death Match
        let deathMatchButton = createButton(title: "Death Match", image: UIImage(named: "Sword")!)
        deathMatchButton.frame = CGRect(x: (view.frame.width - buttonWidth) / 2, y: 100, width: buttonWidth, height: buttonHeight)
        deathMatchButton.addTarget(self, action: #selector(deathMatchButtonPressed), for: .touchUpInside)
        view.addSubview(deathMatchButton)

        // Second button: Capture the Flag
        let captureTheFlagButton = createButton(title: "Capture the Flag", image: UIImage(named: "Flag")!)
        captureTheFlagButton.frame = CGRect(x: (view.frame.width - buttonWidth) / 2, y: 250, width: buttonWidth, height: buttonHeight)
        captureTheFlagButton.addTarget(self, action: #selector(captureTheFlagButtonPressed), for: .touchUpInside)
        view.addSubview(captureTheFlagButton)
    }

    private func createButton(title: String, image: UIImage) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setImage(image, for: .normal)
        button.setBackgroundImage(UIImage(named: "SquareButton"), for: .normal)
        return button
    }

    @objc private func deathMatchButtonPressed() {
        selectedGameMode = .deathMatch
        navigateToGameViewController()
    }

    @objc private func captureTheFlagButtonPressed() {
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
