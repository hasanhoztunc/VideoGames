//
//  Game.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import SwiftyJSON

struct Game {
    var id: Int
    var name: String
    var ratings: Double
    var released: String
    var backgroundImage: URL?
    
    init(from json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        ratings = json["ratings"].doubleValue
        released = json["released"].stringValue
        backgroundImage = json["background_image"].url
    }
}
