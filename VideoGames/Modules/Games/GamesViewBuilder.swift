//
//  GamesViewBuilder.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import UIKit

final class GamesViewBuilder: ViewBuilder {
    
    typealias BuildData = NSNull
    typealias ViewController = GamesViewController
    
    static func build(with buildData: BuildData? = nil) -> ViewController {
        let gamesViewController = GamesViewController.instantiate()
        
        let service = AppService.shared
        
        let router = GameViewRouter()
        router.viewController = gamesViewController
        
        gamesViewController.viewModelBuilder = { [router] in
            let viewModel = GamesViewModel(
                input: $0,
                dependencies: (
                    service: service, ()
                )
            )
            viewModel.router = router
            
            return viewModel
        }
        
        return gamesViewController
    }
}
