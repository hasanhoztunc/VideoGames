//
//  GamesViewModel.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import RxSwift
import RxCocoa
import RxDataSources

protocol GamesViewPresentable {
    
    typealias Input = (
        gameSelected: Observable<GameCellViewPresentable>,
        search: Driver<String>
    )
    typealias Output = (
        gameCells: Observable<[GamesTableViewModel]>,
        hideNothingFound: Observable<Bool>
    )
    typealias Dependencies = (service: AppAPI, ())
    typealias ViewModelBuilder = (Input) -> GamesViewPresentable
    
    var input: Input { get }
    var output: Output { get }
}

final class GamesViewModel: GamesViewPresentable {

    let input: Input
    let output: Output
    private let dependencies: Dependencies
    
    weak var router: GamesRouter?
    
    typealias State = (games: BehaviorRelay<[Game]>, ())
    private let state: State = (games: BehaviorRelay(value: []), ())

    private let bag = DisposeBag()
    
    init(input: Input, dependencies: Dependencies) {
        self.input = input
        self.dependencies = dependencies
        self.output = GamesViewModel.output(input: input, state: state)
        
        process()
    }
}

private extension GamesViewModel {
    
    static func output(input: Input, state: State) -> Output {
        let searchObservable = input
            .search
            .asObservable()
        
        let gamesObservable = state
            .games
            .asObservable()
        
        let cells = Observable
            .combineLatest(searchObservable, gamesObservable)
            .map({ search, games -> [GamesTableViewModel] in
                if !search.isEmpty && search.count > 3 {
                    guard games.count > 0 else { return [] }
                    
                    var cells = [GamesTableViewModel]()
                    
                    let items = games
                        .filter({ $0.name.lowercased().hasPrefix(search.lowercased()) })
                        .map({ GameCellViewModel(from: $0) })
                        .map({ GamesSectionItem.gamesItem(usingViewModel: $0) })
                    
                    let games = GamesTableViewModel.gamesSection(
                        title: "",
                        items: items)
                    cells.append(games)
                    
                    return cells
                } else {
                    guard games.count > 0 else { return [] }
                    let carouselItems = games[...2]
                    let gameItems = games[2...]
                    
                    var cells = [GamesTableViewModel]()
                    
                    let carousel = GamesTableViewModel.carouselSection(
                        title: "",
                        items: [GamesSectionItem.carouselItem(usingViewModel: carouselItems.map({ CarouselCellViewModel(from: $0) }))]
                    )
                    cells.append(carousel)
                    
                    let items = gameItems.map({ GameCellViewModel(from: $0) }).map({ GamesSectionItem.gamesItem(usingViewModel: $0) })
                    let games = GamesTableViewModel.gamesSection(
                        title: "",
                        items: items)
                    cells.append(games)
                    
                    return cells
                }
            })
        
        let nothingFound = Observable
            .combineLatest(searchObservable, cells)
            .map({ search, cells -> Bool in
                if search.count > 3, cells.first?.items.count == 0 {
                    return false
                } else {
                    return true
                }
            })
        
        return (
            gameCells: cells,
            hideNothingFound: nothingFound
        )
    }
    
    func process() {
        fetchGameList()
        
        gameSelected()
    }
    
    func fetchGameList() {
        dependencies
            .service
            .gameList()
            .map({ [state] in
                state.games.accept($0)
            })
            .subscribe()
            .disposed(by: bag)
    }
    
    func gameSelected() {
        input
            .gameSelected
            .map({ [weak self] in
                self?.router?.routeToGameDetail(with: $0.id)
            })
            .asDriver(onErrorDriveWith: .empty())
            .drive()
            .disposed(by: bag)
    }
}
