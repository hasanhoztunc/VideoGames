//
//  Keychain.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 18.07.2021.
//

import KeychainSwift

final class Keychain {
    
    private init() {}
    
    static let Shared = Keychain()
    
    let Chain = KeychainSwift()
}
