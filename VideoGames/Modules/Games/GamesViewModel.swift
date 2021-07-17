//
//  GamesViewModel.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import RxSwift
import RxCocoa
import RxDataSources

typealias GamesSection = SectionModel<Int, GameCellViewPresentable>

protocol GamesViewPresentable {
    
    typealias Input = (
        gameSelected: Observable<GameCellViewPresentable>, ()
    )
    typealias Output = (
        gameCells: Driver<[GamesSection]>, ()
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
        self.output = GamesViewModel.output(state: state)
        
        process()
    }
}

private extension GamesViewModel {
    
    static func output(state: State) -> Output {
        let cells = state
            .games
            .map({ games -> [GameCellViewPresentable] in
                games.map({ GameCellViewModel(from: $0) })
            })
            .map({ [GamesSection(model: 0, items: $0)] })
            .asDriver(onErrorJustReturn: [])
        
        return (
            gameCells: cells, ()
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
