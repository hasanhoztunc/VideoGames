//
//  FavoritesViewBuilder.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import UIKit

final class FavoritesViewBuilder: ViewBuilder {
    typealias BuildData = NSNull
    
    typealias ViewController = FavoritesViewController
    
    static func build(with buildData: BuildData? = nil) -> ViewController {
        FavoritesViewController.instantiate()
    }
}
