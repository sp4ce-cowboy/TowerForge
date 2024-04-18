//
//  CustomAchievementCell.swift
//  TowerForge
//
//  Created by Rubesh on 19/4/24.
//

import Foundation
import UIKit

class CustomAchievementCell: UITableViewCell {
    @IBOutlet var achievementImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var statusImageView: UIImageView!
}

class CustomMissionCell: UITableViewCell {
    @IBOutlet var missionImageView: UIImageView!
    @IBOutlet var missionNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var statusImageView: UIImageView!
}


