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
    
    private let nothingFoundaLabel: UILabel = {
        let label = UILabel()
        label.text = "Üzgünüz, aradığınız oyun bulunamadı!"
        label.textAlignment = .center
        
        return label
    }()
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<GamesTableViewModel>(configureCell: { dataSource, collectionView, indexPath, item in
        
        switch dataSource[indexPath] {
        case let .carouselItem(usingViewModel: model):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GamesViewController.CarouselCellIdentifier, for: indexPath) as! CarouselCell
            cell.configure(usingViewModel: model)
            
            return cell
        case let .gamesItem(usingViewModel: model):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GamesViewController.GameCellIdentifier, for: indexPath) as! GameCell
            cell.configure(usingViewModel: model)
            
            return cell
        }
    })
    
    private static let CarouselCellIdentifier = "CarouselCell"
    private static let GameCellIdentifier = "GameCell"
    
    private var viewModel: GamesViewPresentable!
    var viewModelBuilder: GamesViewPresentable.ViewModelBuilder!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = viewModelBuilder((
            gameSelected: collectionView.rx.modelSelected(GameCellViewPresentable.self).asObservable(),
            search: searchTextField.rx.text.orEmpty.asDriver()
        ))
        
        setupUI()
        setupBindings()
    }
}

private extension GamesViewController {
    
    func setupUI() {
        collectionView.register(with: GamesViewController.GameCellIdentifier)
        collectionView.register(with: GamesViewController.CarouselCellIdentifier)
        collectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = .zero
        layout.sectionInset = UIEdgeInsets(top: .zero, left: 20, bottom: .zero, right: 20)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        nothingFoundaLabel.frame = CGRect(x: .zero, y: .zero, width: view.frame.size.width, height: view.frame.size.height)
    }
    
    func setupBindings() {
        viewModel
            .output
            .gameCells
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        viewModel
            .output
            .hideNothingFound
            .map({ [weak self] in
                guard let self = self else { return }
                if $0 {
                    self.collectionView.backgroundView = nil
                } else {
                    self.collectionView.backgroundView = self.nothingFoundaLabel
                }
            })
            .subscribe()
            .disposed(by: bag)
    }
}

extension GamesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size: CGSize = CGSize(width: collectionView.frame.width, height: 60)
        searchTextField
            .rx
            .text
            .orEmpty
            .map({
                if $0.count < 4 && indexPath.section == 0 {
                    size = CGSize(width: collectionView.frame.width, height: 400)
                } else if $0.count < 4 && indexPath.section != 0 {
                    size = CGSize(width: collectionView.frame.width, height: 60)
                } else if $0.count > 3 {
                    size = CGSize(width: collectionView.frame.width, height: 60)
                }
            })
            .subscribe()
            .disposed(by: bag)
        
        return size
    }
}
