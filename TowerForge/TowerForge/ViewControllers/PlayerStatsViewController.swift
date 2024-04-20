//
//  PlayerStatsViewController.swift
//  TowerForge
//
//  Created by Rubesh on 18/4/24.
//

import Foundation
import UIKit

class PlayerStatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private var achievementsView: UITableView!
    @IBOutlet private var rankNameLabel: UILabel!
    @IBOutlet private var characterImage: UIImageView!

    var achievements: AchievementsDatabase = getAchievements()
    var rank: Rank = getRank()

    static func getAchievements() -> AchievementsDatabase {
        let statsEngine = StatisticsEngine()
        let achEngine = statsEngine.inferenceEngines[AchievementsEngine.asType] as? AchievementsEngine
        achEngine!.achievementsDatabase.setToDefault()
        return achEngine!.achievementsDatabase
    }

    static func getRank() -> Rank {
        let statsEngine = StatisticsEngine()
        let rankEngine = statsEngine.inferenceEngines[RankingEngine.asType] as? RankingEngine
        return rankEngine!.currentRank
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        achievementsView.delegate = self
        achievementsView.dataSource = self
        self.rank = Self.getRank()
        // rankImageView.image = UIImage(named: currentRank.imageIdentifer)
        rankNameLabel.text = String("--- Rank: \(rank.rawValue) ---")

        characterImage.image = UIImage(named: "melee-1")
        reloadAchievements()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        achievements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                       for: indexPath) as? CustomAchievementCell else {
            fatalError("Could not dequeue CustomAchievementCell")
        }

        let achievementPair = achievements.asSortedArray[indexPath.row]
        let achievement = achievementPair.value

        // Configure the cell elements
        cell.nameLabel.text = achievement.name
        cell.descriptionLabel.text = achievement.description
        cell.achievementImageView.image = UIImage(named: achievement.imageIdentifier)
        cell.progressView.progress = Float(achievement.overallProgressRateRounded)
        // cell.progressPercentage.text = String(describing: Float(achievement.overallProgressRateRounded))
        let statusImageName = achievement.isComplete ? "checkmark.circle" : "x.circle"
        cell.statusImageView.image = UIImage(systemName: statusImageName)

        return cell
    }

    func reloadAchievements() {
        achievementsView.reloadData()
        rankNameLabel.reloadInputViews()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row with animation
        tableView.deselectRow(at: indexPath, animated: true)

        // Get the selected achievement
        let achievementPair = achievements.asSortedArray[indexPath.row]
        let achievement = achievementPair.value

        // Show a detail view controller
        // TODO: need to implement the logic for showing the details
        // showAchievementDetails(achievement)
    }

}
