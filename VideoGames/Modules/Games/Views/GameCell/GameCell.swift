//
//  GameCell.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import UIKit

import SDWebImage

final class GameCell: UICollectionViewCell {

    @IBOutlet private weak var gamePhotoImageView: UIImageView!
    @IBOutlet private weak var gameNameLabel: UILabel!
    @IBOutlet private weak var gameRatingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        gamePhotoImageView.sd_cancelCurrentImageLoad()
    }
    
    func configure(usingViewModel viewModel: GameCellViewPresentable) {
        gamePhotoImageView.sd_setImage(with: viewModel.backgroundImage)
        gameNameLabel.text = viewModel.name
        gameRatingLabel.text = "\(viewModel.rating) - \(viewModel.released)"
    }
}
