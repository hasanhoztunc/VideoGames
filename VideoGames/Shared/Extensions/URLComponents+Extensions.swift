//
//  URLComponents+Extensions.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import Foundation

extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: String]) {
        queryItems = parameters.map({ URLQueryItem(name: $0.key, value: $0.value) })
    }
}
