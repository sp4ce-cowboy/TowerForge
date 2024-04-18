//
//  RankView.swift
//  TowerForge
//
//  Created by Rubesh on 19/4/24.
//

import Foundation
import UIKit

class RankView: UIView {
    let imageView = UIImageView()
    let textLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        // Set up the image view
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit // Adjust as needed
        addSubview(imageView)

        // Set up the text label
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0 // Wrap text as needed
        addSubview(textLabel)

        // Add constraints for layout
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor), // Makes the image view square

            textLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(with rank: Rank) {
        imageView.image = UIImage(named: rank.imageIdentifer)
        ?? UIImage(systemName: "checkmark.circle")

        textLabel.text = rank.rawValue
    }
}
