//
//  FavoritesViewModel.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 18.07.2021.
//

import RxSwift
import RxCocoa
import RxDataSources

typealias FavoritesSection = SectionModel<Int, GameCellViewPresentable>

protocol FavoritesViewPresentable {
    
    typealias Input = ()
    typealias Output = (
        favoriteCells: Driver<[FavoritesSection]>, ()
    )
    typealias ViewModelBuilder = (Input) -> FavoritesViewPresentable
    
    var input: Input { get }
    var output: Output { get }
}

final class FavoritesViewModel: FavoritesViewPresentable {
    
    let input: Input
    let output: Output
    
    typealias State = (favorites: BehaviorRelay<[GameDetail]>, ())
    private let state: State = (favorites: BehaviorRelay(value: []), ())
    
    init(input: Input) {
        self.input = input
        self.output = FavoritesViewModel.output(state: state)
        
        process()
    }
}

private extension FavoritesViewModel {
    
    static func output(state: State) -> Output {
        let cells = state
            .favorites
            .asObservable()
            .map({ favs in
                favs.map({ GameCellViewModel(from: $0) })
            })
            .map({ [FavoritesSection(model: 0, items: $0)] })
            .asDriver(onErrorJustReturn: [])
        
        return (
            favoriteCells: cells, ()
        )
    }
    
    func process() {
        fetchFavorites()
        
        NotificationCenter.default.addObserver(self, selector: #selector(favoriteDidAppend(_:)), name: .FavoriteDidAppend, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(favoriteDidRemove(_:)), name: .FavoriteDidRemove, object: nil)
    }
    
    func fetchFavorites() {
        guard let favoritesData = Keychain.Shared.Chain.getData(KeychainAPI.Favorites),
              let favorites = try? JSONDecoder().decode([GameDetail].self, from: favoritesData) else { return }
        
        state.favorites.accept(favorites)
    }
    
    @objc
    func favoriteDidRemove(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?,
              let gameID = dict["gameID"] as? Int else { return }
        let favorites = state.favorites.value
        let filteredFavorites = favorites.filter({ $0.id != gameID })
        
        state.favorites.accept(filteredFavorites)
    }
    
    @objc
    func favoriteDidAppend(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?,
              let game = dict["game"] as? GameDetail else { return }
        
        state.favorites.accept(state.favorites.value + [game])
    }
}
