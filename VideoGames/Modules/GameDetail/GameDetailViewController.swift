//
//  GameDetailViewController.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import UIKit

import RxCocoa
import RxSwift
import RxDataSources

import SDWebImage

final class GameDetailViewController: UIViewController {

    @IBOutlet private weak var gameImageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    private let dataSource = RxTableViewSectionedReloadDataSource<GameDetailSectionItem>(configureCell: { dataSource, tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: GameDetailViewController.GameCellIdentifier, for: indexPath) as! GameDetailCell
        cell.configure(usingViewModel: item)
        
        return cell
    })
    
    private var viewModel: GameDetailViewPresentable!
    var viewModelBuilder: GameDetailViewPresentable.ViewModelBuilder!
    
    private static let GameCellIdentifier = "GameDetailCell"
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = viewModelBuilder((
            favorite: favoriteButton.rx.tap.asDriver(), ()
        ))
        
        setupUI()
        setupBindings()
    }
}

private extension GameDetailViewController {
        
    func setupUI() {
        tableView.register(with: GameDetailViewController.GameCellIdentifier)
    }
    
    func setupBindings() {
        viewModel
            .output
            .gamePhoto
            .map({ [gameImageView] in
                gameImageView?.sd_setImage(with: $0)
            })
            .subscribe()
            .disposed(by: bag)
        
        viewModel
            .output
            .detailCells
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        viewModel
            .output
            .isFavorite
            .map({ [favoriteButton] in
                if $0 {
                    favoriteButton?.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
                } else {
                    favoriteButton?.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
                }
            })
            .asDriver(onErrorDriveWith: .empty())
            .drive()
            .disposed(by: bag)
    }
}
