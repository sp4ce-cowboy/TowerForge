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
    @IBOutlet private var modeButton: UIButton!
    @IBOutlet private var modeLabel: UILabel!

    deinit {
        gameRoom?.deleteRoom()
        gameRoom = nil
        currentPlayer = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gameRoom?.gameRoomDelegate = self
        setUpModeButton()
        updatePlayerList()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? GameViewController {
            destVC.currentPlayer = currentPlayer
            destVC.roomId = gameRoom?.roomId
            destVC.isHost = currentPlayer?.userPlayerId == gameRoom?.host
            destVC.gameMode = gameRoom?.gameMode
            gameRoom?.deleteRoom()
        }
    }

    @IBAction private func onStartButtonPressed(_ sender: Any) {
        gameRoom?.updatePlayerReady { _ in
            self.startButton.isHidden = true
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
    }

    private func setUpModeButton() {
        var menuChildren: [UIAction] = []
        let ctfChild = UIAction(title: "Capture The Flag", discoverabilityTitle: Mode.captureTheFlag.rawValue,
                                handler: { _ in self.selectGameMode(.captureTheFlag) })
        let deathMatchChild = UIAction(title: "Death Match", discoverabilityTitle: Mode.deathMatch.rawValue,
                                       handler: { _ in self.selectGameMode(.deathMatch) })

        menuChildren.append(ctfChild)
        menuChildren.append(deathMatchChild)

        modeButton.menu = UIMenu(options: [.singleSelection], children: menuChildren)
        modeButton.isUserInteractionEnabled = self.currentPlayer?.userPlayerId == self.gameRoom?.host
        modeButton.setTitleColor(.clear, for: .normal)
        updateSelectedGameMode()
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
            performSegue(withIdentifier: "segueToGame", sender: self)
        }

        if self.currentPlayer?.userPlayerId == self.gameRoom?.host {
            modeButton.isUserInteractionEnabled = true
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

    private func selectGameMode(_ mode: Mode) {
        if self.currentPlayer?.userPlayerId == self.gameRoom?.host {
            self.gameRoom?.updateGameMode(to: mode)
        }
    }

    private func updateSelectedGameMode() {
        guard let mode = gameRoom?.gameMode, let menuChildren = modeButton.menu?.children as? [UIAction] else {
            return
        }

        for child in menuChildren {
            let state: UIMenuElement.State = mode.rawValue == child.discoverabilityTitle ? .on : .off
            child.state = state

            if state == .on {
                modeLabel.text = child.title
            }
        }
    }
 }

 extension GameWaitingRoomViewController: GameRoomDelegate {
    func onRoomChange() {
        // Update the player list UI when the room changes
        updatePlayerList()
        updateSelectedGameMode()

        // Enable startButton if roomState changes to waitingForBothConfirmation
        if gameRoom?.roomState == .waitingForBothConfirmation || gameRoom?.roomState == .waitingForFinalConfirmation {
            startButton.isEnabled = true
        } else {
            startButton.isEnabled = false
        }
    }
}
