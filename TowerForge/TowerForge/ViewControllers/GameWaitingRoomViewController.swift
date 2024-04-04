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
    override func viewDidLoad() {
        super.viewDidLoad()
        print(gameRoom)
        gameRoom?.gameRoomDelegate = self
        updatePlayerList()
    }
    @IBAction private func onLeaveButtonPressed(_ sender: Any) {
        guard let player = currentPlayer else {
            return
        }
        self.gameRoom?.leaveRoom(player: player, completion: { success in
            if !success {
                return
            } else {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "segueToGameRoom", sender: self)
                }
            }
        })
        // performSegue(withIdentifier: "segueToGameRoom", sender: self)
    }

    @IBOutlet var ListStackView: UIStackView!
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
    }
}
