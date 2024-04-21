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
    @IBOutlet private var missionsView: UITableView!

    @IBOutlet private var rankNameLabel: UILabel!
    @IBOutlet private var characterImage: UIImageView!
    @IBOutlet private var rankProgress: UIProgressView!

    @IBOutlet private var currentExp: UILabel!
    @IBOutlet private var totalKills: UILabel!
    @IBOutlet private var totalDeaths: UILabel!
    @IBOutlet private var kdRatio: UILabel!
    @IBOutlet private var totalGames: UILabel!

    @IBOutlet private var pte: UILabel!
    @IBOutlet private var cpl: UILabel!
    @IBOutlet private var sgt: UILabel!
    @IBOutlet private var lta: UILabel!
    @IBOutlet private var cpt: UILabel!
    @IBOutlet private var maj: UILabel!
    @IBOutlet private var col: UILabel!
    @IBOutlet private var gen: UILabel!

    // static var staticEngine = StatisticsEngine(with: StorageHandler())
    var statisticsEngine = StatisticsEngine(with: StorageHandler())
    var statisticsDatabase: StatisticsDatabase { statisticsEngine.statisticsDatabase }
    var achievements: AchievementsDatabase = getAchievements()
    var missions: MissionsDatabase = getMissions()
    var rankingEngine: RankingEngine { RankingEngine(statisticsEngine) }

    var rank: Rank { rankingEngine.currentRank }
    var exp: String { rankingEngine.currentExpAsString }
    var kd: Double { rankingEngine.currentKd }
    var kills: Int { Int(rankingEngine.getPermanentValueFor(TotalKillsStatistic.self)) }
    var deaths: Int { Int(rankingEngine.getPermanentValueFor(TotalDeathsStatistic.self)) }
    var games: Int { Int(rankingEngine.getPermanentValueFor(TotalGamesStatistic.self)) }

    static func getMissions() -> MissionsDatabase {
        let statsEngine = StatisticsEngine(with: StorageHandler())
        let missionsEngine = statsEngine.inferenceEngines[MissionsEngine.asType] as? MissionsEngine
        missionsEngine!.missionsDatabase.setToDefault()
        return missionsEngine!.missionsDatabase
    }

    static func getAchievements() -> AchievementsDatabase {
        let statsEngine = StatisticsEngine(with: StorageHandler())
        let achEngine = statsEngine.inferenceEngines[AchievementsEngine.asType] as? AchievementsEngine
        achEngine!.achievementsDatabase.setToDefault()
        return achEngine!.achievementsDatabase
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        achievementsView.delegate = self
        achievementsView.dataSource = self
        missionsView.delegate = self
        missionsView.dataSource = self

        achievementsView.allowsSelection = false
        missionsView.allowsSelection = false

        initializePlayerStats()
        initializeRanks()
        highlightCurrentRank()
        reloadAll()
    }

    func initializePlayerStats() {
        rankNameLabel.text = String("--- Rank: \(rank.rawValue) ---")
        characterImage.image = rank.isOfficer() ? UIImage(named: "Shooter-1") : UIImage(named: "melee-1")
        currentExp.text = String("XP: \(exp)")
        totalKills.text = String("Kills: \(kills)")
        totalDeaths.text = String("Deaths: \(deaths)")
        totalGames.text = String("Games: \(games)")
        kdRatio.text = String("K/D Ratio: ") + String(format: "%.2f", kd)

        rankProgress.progress = Float(rankingEngine.percentageToNextRank())
        Logger.log("Current progress is \(rankProgress.progress)", self)
    }

    func initializeRanks() {
        pte.text = "PTE"
        cpl.text = "CPL"
        sgt.text = "SGT"
        lta.text = "LTA"
        cpt.text = "CPT"
        maj.text = "MAJ"
        col.text = "COL"
        gen.text = "GEN"
    }

    func highlightCurrentRank() {
        switch rank {
        case .PRIVATE:
            pte.textColor = .red
        case .CORPORAL:
            cpl.textColor = .red
        case .SERGEANT:
            sgt.textColor = .red
        case .LIEUTENANT:
            lta.textColor = .red
        case .CAPTAIN:
            cpt.textColor = .red
        case .MAJOR:
            maj.textColor = .red
        case .COLONEL:
            col.textColor = .red
        case .GENERAL:
            gen.textColor = .red
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == achievementsView {
            return achievements.count
        } else if tableView == missionsView {
            return missions.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == achievementsView {
            return getCustomAchievementCell(tableView: tableView, cellForRowAt: indexPath)
        }

        return getCustomMissionCell(tableView: tableView, cellForRowAt: indexPath)
    }

    func getCustomAchievementCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        cell.statusImageView.tintColor = achievement.isComplete ? .green : .red

        return cell
    }

    func getCustomMissionCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let missionCell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                              for: indexPath) as? CustomMissionCell else {
            fatalError("Could not dequeue CustomMissionCell")
        }

        let missionPair = missions.asSortedArray[indexPath.row]
        let mission = missionPair.value

        // Configure the cell elements
        missionCell.missionNameLabel.text = mission.name
        missionCell.descriptionLabel.text = mission.description
        missionCell.missionImageView.image = UIImage(named: mission.imageIdentifier)
        let statusImageName = mission.isComplete ? "checkmark.circle" : "x.circle"
        missionCell.statusImageView.image = UIImage(systemName: statusImageName)
        missionCell.statusImageView.tintColor = mission.isComplete ? .green : .red

        return missionCell
    }

    func reloadAll() {
        achievementsView.reloadData()
        missionsView.reloadData()
        rankNameLabel.reloadInputViews()
        view.reloadInputViews()
    }

}
