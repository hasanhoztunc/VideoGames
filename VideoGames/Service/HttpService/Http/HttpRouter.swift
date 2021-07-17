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
            "x-rapidapi-key": ProcessInfo.processInfo.environment["x-rapidapi-key"] ?? "",
            "x-rapidapi-host": ProcessInfo.processInfo.environment["x-rapidapi-host"] ?? ""
        ]
    }
    var parameters: Parameters? {
        [
            "key": ProcessInfo.processInfo.environment["key"] ?? ""
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
