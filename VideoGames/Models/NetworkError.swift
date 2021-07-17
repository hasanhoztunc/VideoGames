//
//  NetworkError.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import Foundation

enum NetworkError: Error {
    case internalError
    case unauthorized
    case custom(description: String)
}

extension NetworkError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .custom(description: let description):
            return description
        case .internalError:
            return "Internal Error"
        case .unauthorized:
            return "Unauthorized"
        }
    }
}
