//
//  ViewBuilder.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import UIKit

protocol ViewBuilder {
    
    associatedtype BuildData
    associatedtype ViewController
    
    static func build(with buildData: BuildData?) -> ViewController
}
