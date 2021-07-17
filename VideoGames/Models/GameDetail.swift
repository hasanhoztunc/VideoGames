//
//  GameDetail.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 17.07.2021.
//

import SwiftyJSON

struct GameDetail {
    var id: Int
    var name: String
    var rating: Double
    var released: String
    var description: String
    var backgroundImage: URL?
    
    init(from json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        rating = json["rating"].doubleValue
        released = json["released"].stringValue
        description = json["description_raw"].stringValue
        backgroundImage = json["background_image"].url
    }
}
