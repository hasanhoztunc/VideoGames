//
//  GameCellViewModel.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import struct Foundation.URL

protocol GameCellViewPresentable {
    var id: Int { get }
    var name: String { get }
    var rating: Double { get }
    var released: String { get }
    var backgroundImage: URL? { get }
}

struct GameCellViewModel: GameCellViewPresentable {
    var id: Int
    var name: String
    var rating: Double
    var released: String
    var backgroundImage: URL?
    
    init(from game: Game) {
        id = game.id
        name = game.name
        rating = game.ratings
        released = game.released
        backgroundImage = game.backgroundImage
    }
    
    init(from gameDetail: GameDetail) {
        id = gameDetail.id
        name = gameDetail.name
        rating = gameDetail.rating
        released = gameDetail.released
        backgroundImage = gameDetail.backgroundImage
    }
}
