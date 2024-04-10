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
        let viewControllers = RankType.allCases.map { type -> UINavigationController in
            let leaderboardVC = LeaderboardViewController(type: type)
            let navigationController = UINavigationController(rootViewController: leaderboardVC)
            navigationController.tabBarItem.title = type.rawValue
            return navigationController
        }

        self.setViewControllers(viewControllers, animated: false)
    }
}
