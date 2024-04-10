//
//  LeaderboardViewController.swift
//  TowerForge
//
//  Created by Vanessa Mae on 10/04/24.
//

import Foundation
import UIKit

class LeaderboardViewController: UIViewController {
    private let type: RankType

    init(type: RankType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchTopRanks(type: self.type.rawValue)
    }

    private func setupViews() {
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func fetchTopRanks(type: String) {
        let rank = GameRankProvider(type: type)
        rank.getTopRanks { data, _ in
            guard let result = data else {
                return
            }
            self.displayLeaderboard(ranks: result)
        }
    }

    private func displayLeaderboard(ranks: [GameRankData]) {
        for rankData in ranks {
            let rankLabel = UILabel()
            rankLabel.text = "\(rankData.username): \(rankData.score)"
            rankLabel.textColor = .black
            stackView.addArrangedSubview(rankLabel)
        }
    }
}
