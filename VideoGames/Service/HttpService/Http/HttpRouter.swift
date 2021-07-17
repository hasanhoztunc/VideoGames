//
//  HttpRouter.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import Alamofire

protocol HttpRouter {
    
    var baseURLString: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    
    func body() throws -> Data?
    
    func request(httpService service: HttpService) throws -> DataRequest
}

extension HttpRouter {
    
    var baseURLString: String {
        API.baseURL
    }
    var method: HTTPMethod { .get }
    var headers: HTTPHeaders? {
        [
            "Content-Type": "application/json",
            "x-rapidapi-key": "e1577839cbmshb7b56f7ae2df9a1p153b52jsn5a47e57ba05b",
            "x-rapidapi-host": "rawg-video-games-database.p.rapidapi.com"
        ]
    }
    var parameters: Parameters? {
        [
            "key": "9ae11778380c4699980bfa7fc6ad0c99"
        ]
    }
    
    func body() throws -> Data? { nil }
    
    func asURLRequest() throws -> URLRequest {        
        var urlComponents = URLComponents()
        urlComponents.scheme = API.baseURLScheme
        urlComponents.host = API.baseURLHost
        urlComponents.path = path
        
        if let params = parameters,
           let parms = params as? [String: String] {
            urlComponents.setQueryItems(with: parms)
        }
        
        var request = try URLRequest(url: urlComponents, method: method, headers: headers)
        request.httpBody = try body()
        
        return request
    }
    
    func request(httpService service: HttpService) throws -> DataRequest {
        try service.request(asURLRequest())
    }
}
