//
//  GameDetailViewModel.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import class Foundation.JSONDecoder

import RxSwift
import RxCocoa
import RxDataSources

typealias GameDetailSectionItem = SectionModel<Int, GameDetailCellViewPresentable>

protocol GameDetailViewPresentable {
    
    typealias Input = (
        favorite: Driver<Void>, ()
    )
    typealias Output = (
        gamePhoto: Observable<URL?>,
        detailCells: Driver<[GameDetailSectionItem]>,
        isFavorite: Observable<Bool>
    )
    typealias Dependencies = (gameID: Int, service: AppAPI)
    typealias ViewModelBuilder = (Input) -> GameDetailViewPresentable
    
    var input: Input { get }
    var output: Output { get }
}

final class GameDetailViewModel: GameDetailViewPresentable {
    
    let input: Input
    let output: Output
    private let dependencies: Dependencies
    
    typealias State = (
        photo: BehaviorRelay<URL?>,
        gameDetail: BehaviorRelay<GameDetail?>,
        gameDetailCells: BehaviorRelay<[GameDetailCellViewPresentable]>,
        isFavorite: BehaviorRelay<Bool>
    )
    private let state: State = (
        photo: BehaviorRelay(value: nil),
        gameDetail: BehaviorRelay(value: nil),
        gameDetailCells: BehaviorRelay(value: []),
        isFavorite: BehaviorRelay(value: false)
    )
    
    private let bag = DisposeBag()
    
    init(input: Input, dependencies: Dependencies) {
        self.input = input
        self.dependencies = dependencies
        self.output = GameDetailViewModel.output(state: state)
        
        process()
    }
}

private extension GameDetailViewModel {
    
    static func output(state: State) -> Output {
        let cells = state
            .gameDetailCells
            .map({ [GameDetailSectionItem(model: 0, items: $0)] })
            .asDriver(onErrorJustReturn: [])
        
        return (
            gamePhoto: state.photo.asObservable(),
            detailCells: cells,
            isFavorite: state.isFavorite.asObservable()
        )
    }
    
    func process() {
        getGame()
        
        favorite()
    }
    
    func getGame() {
        dependencies
            .service
            .game(gameID: dependencies.gameID)
            .map({ [state] in
                state.photo.accept($0.backgroundImage)
                state.gameDetail.accept($0)
                state.gameDetailCells.accept([GameDetailCellViewModel(from: $0)])
                
                let favoritesData = Keychain.Shared.Chain.getData(KeychainAPI.Favorites) ?? Data()
                let favorites = try? JSONDecoder().decode([GameDetail].self, from: favoritesData)
                if let _ = favorites?.filter({ $0.id == self.dependencies.gameID }).first {
                    state.isFavorite.accept(true)
                }
            })
            .subscribe()
            .disposed(by: bag)
    }
    
    func favorite() {
        input
            .favorite
            .asObservable()
            .map({ [weak self] in
                guard let self = self else { return }
                
                let favoritesData = Keychain.Shared.Chain.getData(KeychainAPI.Favorites) ?? Data()
                var favorites = try? JSONDecoder().decode([GameDetail].self, from: favoritesData)
                
                if let _ = favorites?.filter({ $0.id == self.dependencies.gameID }).first {
                    let filteredFavorites = favorites?.filter({ $0.id != self.dependencies.gameID })
                    guard let encodedFavorites = try? JSONEncoder().encode(filteredFavorites) else { return }
                    
                    Keychain.Shared.Chain.set(encodedFavorites, forKey: KeychainAPI.Favorites)
                    self.state.isFavorite.accept(false)
                    
                    let userInfo = [
                        "gameID": self.dependencies.gameID
                    ]
                    
                    NotificationCenter.default.post(name: .FavoriteDidRemove, object: nil, userInfo: userInfo)
                    
                } else {
                    guard let gameDetail = self.state.gameDetail.value else { return }
                    if favorites == nil {
                        favorites = [gameDetail]
                    } else {
                        favorites?.append(gameDetail)
                    }
                    
                    guard let gameDetailData = try? JSONEncoder().encode(favorites) else { return }
                    Keychain.Shared.Chain.set(gameDetailData, forKey: KeychainAPI.Favorites)
                    self.state.isFavorite.accept(true)
                    
                    let userInfo = [
                        "game": gameDetail
                    ]
                    
                    NotificationCenter.default.post(name: .FavoriteDidAppend, object: nil, userInfo: userInfo)
                    
                }
            })
            .subscribe()
            .disposed(by: bag)
    }
}
