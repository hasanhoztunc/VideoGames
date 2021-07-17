//
//  AppHttpRouter.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import Alamofire

enum AppHttpRouter {
    case gamelist
    case game(gameID: Int)
}

extension AppHttpRouter: HttpRouter {
    
    var path: String {
        switch self {
        case .gamelist:
            return API.GameList.path()
        case .game(gameID: let gameID):
            return "\(API.GameList.path())/\(gameID)"
        }
    }
}
