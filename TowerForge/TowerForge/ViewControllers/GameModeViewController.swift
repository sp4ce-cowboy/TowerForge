//
//  GameModeViewController.swift
//  TowerForge
//
//  Created by Vanessa Mae on 28/03/24.
//
import UIKit

class GameModeViewController: UIViewController {
    @IBOutlet private var rankingView: UIView!
    @IBOutlet private var loginButtonLabel: UILabel!

    var selectedGameMode = Mode.captureTheFlag

    let levelModes: [Int: Mode] = [
        1: .survivalLevelOne,
        2: .survivalLevelTwo,
        3: .survivalLevelThree
    ]

    private let authenticationProvider = AuthenticationProvider()
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticationProvider.addObserver(self)
        if authenticationProvider.isUserLoggedIn() {
            loginButtonLabel.text = "Logout"
            rankingView.isHidden = false
        } else {
            loginButtonLabel.text = "Login"
            rankingView.isHidden = true
        }
    }

    deinit {
        authenticationProvider.removeObserver(self)
   }

    @IBAction private func onRankingPressed(_ sender: Any) {
    }

    @IBAction private func survivalMatchPressed(_ sender: Any) {
        LevelPopupViewController.showDialogBox(parentVC: self)
    }

    @IBAction private func deathMatchButtonPressed(_ sender: UIButton) {
        selectedGameMode = .deathMatch
        navigateToGameViewController()
    }

    @IBAction private func captureTheFlagButtonPressed(_ sender: UIButton) {
        selectedGameMode = .captureTheFlag
        navigateToGameViewController()
    }

    @IBAction private func onLoginViewPressed(_ sender: Any) {
        if authenticationProvider.isUserLoggedIn() {
            authenticationProvider.logout { err in
                if let err = err {
                    print(err)
                }
            }
        } else {
            guard !authenticationProvider.isUserLoggedIn() else {
                return
            }

            performSegue(withIdentifier: "segueToLogin", sender: self)
        }
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
        loginButtonLabel.text = "Logout"
        rankingView.isHidden = false
    }

    func onLogout() {
        loginButtonLabel.text = "Login"
        rankingView.isHidden = true
    }
}

extension GameModeViewController: LevelPopupDelegate {
    func handleLevel(level: Int) {
        if let levelMode = levelModes[level] {
            selectedGameMode = levelMode
            navigateToGameViewController()
        }
    }
}
