//
//  UICollectionView+Extensions.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import UIKit

extension UICollectionView {
    
    func register(with identifier: String) {
        self.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
}
