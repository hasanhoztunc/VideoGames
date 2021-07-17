//
//  GameDetailViewBuilder.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import UIKit

final class GameDetailViewBuilder: ViewBuilder {
    typealias BuildData = Int
    
    typealias ViewController = GameDetailViewController
    
    static func build(with buildData: BuildData?) -> ViewController {
        let viewController = GameDetailViewController.instantiate()
        
        let service = AppService.shared
        
        viewController.viewModelBuilder = {
            GameDetailViewModel(
                input: $0,
                dependencies: (
                    gameID: buildData ?? 0,
                    service: service
                )
            )
        }
        
        return viewController
    }
}
