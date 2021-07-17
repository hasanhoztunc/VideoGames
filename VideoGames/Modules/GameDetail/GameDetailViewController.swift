//
//  GameDetailViewController.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import UIKit

final class GameDetailViewController: UIViewController {

    private var viewModel: GameDetailViewPresentable!
    var viewModelBuilder: GameDetailViewPresentable.ViewModelBuilder!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = viewModelBuilder(())
    }
}
