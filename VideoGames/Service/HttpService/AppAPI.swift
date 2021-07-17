//
//  AppAPI.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import RxSwift

protocol AppAPI {
    func gameList() -> Single<[Game]>
    func game(gameID: Int) -> Single<GameDetail>
}
