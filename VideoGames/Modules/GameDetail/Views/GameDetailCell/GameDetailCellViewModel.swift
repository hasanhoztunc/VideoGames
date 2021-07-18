//
//  GameDetailCellViewModel.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 18.07.2021.
//

protocol GameDetailCellViewPresentable {
    var name: String { get }
    var releaseDate: String { get }
    var rate: String { get }
    var description: String { get }
}

struct GameDetailCellViewModel: GameDetailCellViewPresentable {
    var name: String
    var releaseDate: String
    var rate: String
    var description: String
    
    init(from gameDetail: GameDetail) {
        name = gameDetail.name
        releaseDate = gameDetail.released
        rate = "\(gameDetail.rating)"
        description = gameDetail.description
    }
}
