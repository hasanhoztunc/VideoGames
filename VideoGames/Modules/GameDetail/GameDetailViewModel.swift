//
//  GameDetailViewModel.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import RxSwift

protocol GameDetailViewPresentable {
    
    typealias Input = ()
    typealias Output = ()
    typealias Dependencies = (gameID: Int, service: AppAPI)
    typealias ViewModelBuilder = (Input) -> GameDetailViewPresentable
    
    var input: Input { get }
    var output: Output { get }
}

final class GameDetailViewModel: GameDetailViewPresentable {
    
    let input: Input
    let output: Output
    private let dependencies: Dependencies
    
    private let bag = DisposeBag()
    
    init(input: Input, dependencies: Dependencies) {
        self.input = input
        self.dependencies = dependencies
        self.output = GameDetailViewModel.output()
        
        process()
    }
}

private extension GameDetailViewModel {
    
    static func output() -> Output {
        ()
    }
    
    func process() {
        getGame()
    }
    
    func getGame() {
        dependencies
            .service
            .game(gameID: dependencies.gameID)
            .map({
                print($0)
            })
            .subscribe()
            .disposed(by: bag)
    }
}
