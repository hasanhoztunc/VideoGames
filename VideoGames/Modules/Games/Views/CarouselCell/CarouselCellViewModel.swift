//
//  CarouselCellViewModel.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 19.07.2021.
//

import struct Foundation.URL

protocol CarouselCellViewPresentable {
    var id: Int { get }
    var photo: URL? { get }
}

struct CarouselCellViewModel: CarouselCellViewPresentable {
    var id: Int
    var photo: URL?
    
    init(from game: Game) {
        id = game.id
        photo = game.backgroundImage
    }
}
