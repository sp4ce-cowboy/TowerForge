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
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var rankingButton: UIButton!
    var selectedGameMode = Mode.captureTheFlag
    private let authenticationProvider = AuthenticationProvider()
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticationProvider.addObserver(self)
        updateButtonVisibility()
    }

    deinit {
        authenticationProvider.removeObserver(self)
   }

    private func updateButtonVisibility() {
        let authentication = AuthenticationProvider()
        if authentication.isLoggedIn {
            loginButton.isHidden = true
            rankingButton.isHidden = false
        } else {
            loginButton.isHidden = false
            rankingButton.isHidden = true
        }
    }

    @IBAction func onRankingPressed(_ sender: Any) {
    }
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

extension GameModeViewController: AuthenticationDelegate {
    func onLogin() {
        updateButtonVisibility()
    }

    func onLogout() {
        updateButtonVisibility()
    }
}
