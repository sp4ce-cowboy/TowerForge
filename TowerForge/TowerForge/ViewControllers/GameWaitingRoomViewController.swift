//
//  GameWaitingRoomViewController.swift
//  TowerForge
//
//  Created by Vanessa Mae on 03/04/24.
//

import UIKit

class GameWaitingRoomViewController: UIViewController {
    var gameRoom: GameRoom?
    var currentPlayer: GamePlayer?
    @IBOutlet private var ListStackView: UIStackView!

    @IBOutlet private var startButton: UIButton!
    deinit {
        gameRoom = nil
        currentPlayer = nil
        print("deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gameRoom?.gameRoomDelegate = self
        updatePlayerList()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let destVC = segue.destination as? GameViewController else {
            return
        }
        destVC.gameRoom = gameRoom
        destVC.currentPlayer = currentPlayer
    }

    @IBAction private func onStartButtonPressed(_ sender: Any) {
        gameRoom?.updatePlayerReady { state in
            if state == .gameOnGoing {
                self.performSegue(withIdentifier: "segueToGame", sender: self)
            }
        }
    }

    @IBAction private func onLeaveButtonPressed(_ sender: Any) {
        guard let player = currentPlayer else {
            return
        }
        self.gameRoom?.leaveRoom(player: player, completion: { success in
            if !success {
                return
            } else {
                // Pop from navigation stack so that vc and gameroom can be deinit
                self.navigationController?.popViewController(animated: true)
            }
        })
        // performSegue(withIdentifier: "segueToGameRoom", sender: self)
    }

    private func updatePlayerList() {
        ListStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Add player views to the stack view
        if let playerOne = gameRoom?.playerOne {
            let playerOneView = createPlayerView(for: playerOne)
            ListStackView.addArrangedSubview(playerOneView)
        }

        if let playerTwo = gameRoom?.playerTwo {
            let playerTwoView = createPlayerView(for: playerTwo)
            ListStackView.addArrangedSubview(playerTwoView)
        }
        if gameRoom?.roomState == .gameOnGoing {
            self.performSegue(withIdentifier: "segueToGame", sender: self)
        }
    }

    private func createPlayerView(for player: GamePlayer) -> UIView {
        let playerView = UILabel()
        playerView.text = player.userName // Display player's username
        playerView.textAlignment = .center
        playerView.textAlignment = .center
        playerView.font = UIFont(name: "Nosifer-Regular", size: 30.0)
        return playerView
    }
 }

 extension GameWaitingRoomViewController: GameRoomDelegate {
    func onRoomChange() {
        // Update the player list UI when the room changes
        updatePlayerList()

        // Enable startButton if roomState changes to waitingForBothConfirmation
        if gameRoom?.roomState == .waitingForBothConfirmation || gameRoom?.roomState == .waitingForFinalConfirmation {
            startButton.isEnabled = true
        } else {
            startButton.isEnabled = false
        }
    }
}
