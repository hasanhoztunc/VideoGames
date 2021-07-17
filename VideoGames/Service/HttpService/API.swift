//
//  API.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

enum API: String {
    
    static let baseURLScheme = "https"
    static let baseURLHost = "rawg-video-games-database.p.rapidapi.com"
    static let baseURL = "https://rawg-video-games-database.p.rapidapi.com/"
    
    case GameList = "/games"
    
    func path() -> String {
        self.rawValue
    }
}
