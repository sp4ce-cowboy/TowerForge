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
        stackView.backgroundColor = .yellow
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
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
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func displayLeaderboard(ranks: [GameRankData]) {
        for rankData in ranks {
            let rankLabel = UILabel()

            if let customFont = UIFont(name: "Nosifer-Regular", size: 24) {
                rankLabel.font = customFont
            }

            rankLabel.text = "\(rankData.username): \(rankData.score)"
            rankLabel.textColor = .white

            rankLabel.backgroundColor = .gray
            rankLabel.layer.cornerRadius = 8
            rankLabel.layer.masksToBounds = true
            rankLabel.textAlignment = .center
            rankLabel.layoutMargins = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

            rankLabel.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(rankLabel)
        }
    }
}
