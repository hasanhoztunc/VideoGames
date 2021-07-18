//
//  GamesViewRouter.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import UIKit

protocol GamesRouter: class {
    var viewController: GamesViewController? { get }
    
    func routeToGameDetail(with gameID: Int)
}

final class GameViewRouter: GamesRouter {
    weak var viewController: GamesViewController?
    
    func routeToGameDetail(with: Int) {
        let gameDetailViewController = GameDetailViewBuilder.build(with: with)
        
        viewController?.navigationController?.pushViewController(gameDetailViewController, animated: true)
    }
}
