//
//  GamesTableViewModel.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 19.07.2021.
//

import RxDataSources

enum GamesTableViewModel {
    case carouselSection(title: String, items: [GamesSectionItem])
    case gamesSection(title: String, items: [GamesSectionItem])
}

enum GamesSectionItem {
    case carouselItem(usingViewModel: [CarouselCellViewPresentable])
    case gamesItem(usingViewModel: GameCellViewPresentable)
}

extension GamesTableViewModel: SectionModelType {
    typealias Item = GamesSectionItem
    
    init(original: GamesTableViewModel, items: [Item]) {
        switch original {
        case let .carouselSection(title: title, items: items):
            self = .carouselSection(title: title, items: items)
        case let .gamesSection(title: title, items: items):
            self = .gamesSection(title: title, items: items)
        }
    }
    
    var items: [GamesSectionItem] {
        switch self {
        case let .carouselSection(title: _, items: items):
            return items.map({ $0 })
        case let .gamesSection(title: _, items: items):
            return items.map({ $0 })
        }
    }
}
