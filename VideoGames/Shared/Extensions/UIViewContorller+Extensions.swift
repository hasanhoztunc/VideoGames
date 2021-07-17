//
//  UIViewContorller+Extensions.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import UIKit

extension UIViewController {
    
    class func instantiate<T: UIViewController>(from storyboard: UIStoryboard, with identifier: String) -> T {
        storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    class func instantiate(from storyboard: UIStoryboard) -> Self {
        instantiate(from: storyboard, with: String(describing: self))
    }
    
    class func instantiate() -> Self {
        instantiate(from: UIStoryboard(name: String(describing: self), bundle: nil))
    }
    
    func presentFullScreen() {
        modalPresentationStyle = .fullScreen
    }
}
