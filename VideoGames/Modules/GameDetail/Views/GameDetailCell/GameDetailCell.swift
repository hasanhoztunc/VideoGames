//
//  GameDetailCell.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 18.07.2021.
//

import UIKit

final class GameDetailCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var rateLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func configure(usingViewModel viewModel: GameDetailCellViewPresentable) {
        titleLabel.text = viewModel.name
        releaseDateLabel.text = viewModel.releaseDate
        rateLabel.text = viewModel.rate
        descriptionLabel.text = viewModel.description
    }
}
