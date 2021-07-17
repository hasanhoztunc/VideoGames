//
//  HttpService.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import Alamofire

protocol HttpService {
    
    var sessionManager: Session { get }
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest
}
