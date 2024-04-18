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

    var achievements: AchievementsDatabase = getAchievements()

    static func getAchievements() -> AchievementsDatabase {
        let statsEngine = StatisticsEngine()
        let achEngine = statsEngine.inferenceEngines[AchievementsEngine.asType] as? AchievementsEngine

        Logger.log("Count is \(String(describing: achEngine?.achievementsDatabase.achievements.values.count))", self)

        achEngine!.achievementsDatabase.achievements = AchievementsFactory
            .getDefaultAchievementsDatabase(achEngine).achievements

        return achEngine!.achievementsDatabase
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        achievementsView.delegate = self
        achievementsView.dataSource = self
        reloadAchievements()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        achievements.achievements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Sort achievements if necessary and configure the cell
        let achievementPair = Array(achievements.achievements).sorted(by: { $0.key < $1.key })[indexPath.row]
        let achievement = achievementPair.value
        
        cell.textLabel?.text = achievement.name

        return cell
    }

    func reloadAchievements() {
        achievementsView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row with animation
        tableView.deselectRow(at: indexPath, animated: true)

        // Get the selected achievement
        let achievementPair = Array(achievements.achievements).sorted(by: { $0.key < $1.key })[indexPath.row]
        let achievement = achievementPair.value

        // Show a detail view controller
        // TODO: need to implement the logic for showing the details
        // showAchievementDetails(achievement)
    }

}
