//
//  UITableView+Extensions.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 18.07.2021.
//

import UIKit

extension UITableView {
    
    func register(with identifier: String) {
        register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
}
