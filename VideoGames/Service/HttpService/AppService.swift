//
//  AppService.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import RxSwift
import Alamofire
import SwiftyJSON

final class AppService {
    
    private init() {}
    
    static let shared = AppService()
    
    private let httpService: AppHttpService = AppHttpService()
}

extension AppService: AppAPI {
    
    func gameList() -> Single<[Game]> {
        Single.create { [httpService] single -> Disposable in
            
            do {
                try AppHttpRouter
                    .gamelist
                    .request(httpService: httpService)
                    .responseJSON {
                        guard let statusCode = $0.response?.statusCode else {
                            return single(.failure(NetworkError.custom(description: "Network Error. Status Code.")))
                        }
                        switch statusCode {
                        case 200..<400:
                            let response = JSON($0.data ?? Data())
                            
                            let gamesArray = response["results"].arrayValue
                            let games = gamesArray.map({ Game(from: $0) })
                            
                            single(.success(games))
                        case 401:
                            single(.failure(NetworkError.unauthorized))
                        default:
                            single(.failure(NetworkError.internalError))
                        }
                    }
            } catch {
                single(.failure(NetworkError.internalError))
            }
            
            return Disposables.create()
        }
    }
    
    func game(gameID: Int) -> Single<GameDetail> {
        Single.create { [httpService] single -> Disposable in
            
            do {
                try AppHttpRouter
                    .game(gameID: gameID)
                    .request(httpService: httpService)
                    .responseJSON {
                        guard let statusCode = $0.response?.statusCode else {
                            return single(.failure(NetworkError.custom(description: "Network Error. Status Code.")))
                        }
                        switch statusCode {
                        case 200..<400:
                            let response = JSON($0.data ?? Data())
                            let gameDetail = GameDetail(from: response)
                            
                            single(.success(gameDetail))
                        case 401:
                            single(.failure(NetworkError.unauthorized))
                        default:
                            single(.failure(NetworkError.internalError))
                        }
                    }
            } catch {
                single(.failure(NetworkError.internalError))
            }
            
            return Disposables.create()
        }
    }
}
