//
//  LeaderboardSelectionViewController.swift
//  TowerForge
//
//  Created by Vanessa Mae on 10/04/24.
//

import Foundation
import UIKit

class LeaderboardSelectionViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set background image
        let backgroundImage = UIImage(named: "background2")
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.3
        self.view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true

        let viewControllers = RankType.allCases.map { type -> UINavigationController in
            let leaderboardVC = LeaderboardViewController(type: type)

            let navigationController = UINavigationController(rootViewController: leaderboardVC)
            navigationController.tabBarItem.title = type.rawValue

            if let customFont = UIFont(name: "Nosifer-Regular", size: 14) {
                let attributes: [NSAttributedString.Key: Any] = [
                    NSAttributedString.Key.font: customFont
                ]
                navigationController.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
            }

            navigationController.viewControllers.first?
                .view.layoutMargins = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
            return navigationController
        }

        self.setViewControllers(viewControllers, animated: false)
    }
}
