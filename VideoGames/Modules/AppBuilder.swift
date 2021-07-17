//
//  AppBuilder.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import UIKit

final class AppBuilder: ViewBuilder {
    typealias BuildData = NSNull
    
    typealias ViewController = UITabBarController
    
    static func build(with buildData: BuildData? = nil) -> ViewController {
        let gamesViewController = GamesViewBuilder.build()
        let favoritesViewController = FavoritesViewBuilder.build()
        
        let tabbarController = UITabBarController()
        
        gamesViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "homekit"), tag: 1)
        favoritesViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "heart"), tag: 2)
        
        tabbarController.viewControllers = [gamesViewController, favoritesViewController]
        
        return tabbarController
    }
}
