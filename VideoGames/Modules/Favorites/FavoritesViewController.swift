//
//  FavoritesViewController.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

final class FavoritesViewController: UIViewController {

    @IBOutlet private weak var favoritesCollectionView: UICollectionView!
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<FavoritesSection>(configureCell: { dataSource, collectionView, indexPath, item in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesViewController.GameCellIdentifier, for: indexPath) as! GameCell
        cell.configure(usingViewModel: item)
        
        return cell
    })
    
    private static let GameCellIdentifier = "GameCell"
    
    private var viewModel: FavoritesViewPresentable!
    var viewModelBuilder: FavoritesViewPresentable.ViewModelBuilder!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = viewModelBuilder(())
        
        setupUI()
        setupBindings()
    }
}

private extension FavoritesViewController {
    
    func setupUI() {
        favoritesCollectionView.register(with: FavoritesViewController.GameCellIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: favoritesCollectionView.frame.width, height: 60)
        layout.estimatedItemSize = .zero
        layout.sectionInset = UIEdgeInsets(top: .zero, left: 20, bottom: .zero, right: 20)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        favoritesCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func setupBindings() {
        viewModel
            .output
            .favoriteCells
            .drive(favoritesCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
}
