//
//  GameWaitingRoomViewController.swift
//  TowerForge
//
//  Created by Vanessa Mae on 03/04/24.
//

import UIKit

class GameWaitingRoomViewController: UIViewController {

    var gameRoom: GameRoom?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(gameRoom?.playerOne)
        updatePlayerList()
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
        return playerView
    }
 }

 extension GameWaitingRoomViewController: GameRoomDelegate {
    func onRoomChange() {
        // Update the player list UI when the room changes
        updatePlayerList()
    }
}
