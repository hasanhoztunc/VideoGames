//
//  GamesViewController.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

final class GamesViewController: UIViewController {

    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<GamesSection> { (dataSource, collectionView, indexPath, item) in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GamesViewController.GameCellIdentifier, for: indexPath) as! GameCell
        cell.configure(usingViewModel: item)
        
        return cell
    }
    
    private static let GameCellIdentifier = "GameCell"
    
    private var viewModel: GamesViewPresentable!
    var viewModelBuilder: GamesViewPresentable.ViewModelBuilder!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = viewModelBuilder((
            gameSelected: collectionView.rx.modelSelected(GameCellViewPresentable.self).asObservable(), ()
        ))
        
        setupUI()
        setupBindings()
    }
}

private extension GamesViewController {
    
    func setupUI() {
        collectionView.register(with: GamesViewController.GameCellIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: collectionView.frame.width, height: 60)
        layout.estimatedItemSize = .zero
        layout.sectionInset = UIEdgeInsets(top: .zero, left: 20, bottom: .zero, right: 20)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func setupBindings() {
        viewModel
            .output
            .gameCells
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
}
