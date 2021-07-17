//
//  AppHttpService.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import Alamofire

final class AppHttpService: HttpService {
    
    var sessionManager: Session = Session.default
    
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
        sessionManager.request(urlRequest)
    }
}
