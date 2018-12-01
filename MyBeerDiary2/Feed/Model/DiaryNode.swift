//
//  DiaryNode.swift
//  MyBeerDiary2
//
//  Created by 青柳瑞子 on 2018/10/06.
//  Copyright © 2018 青柳瑞子. All rights reserved.
//

import UIKit

struct DiaryNode {
    var id: String?
    let date: String?
    let drink: String?
    let pictureUrl: String?
    let coordinates: Coordinates?
}

struct Coordinates {
    let latitude: Double
    let longitude: Double
}

extension Coordinates {
    init(dict: [String : AnyObject]) {
        latitude = dict["latitude"] as! Double
        longitude = dict["longitude"] as! Double
    }
}

extension DiaryNode {
    
    init(id: String, data: [String : AnyObject]) {
        self.id = id
        date = data["date"] as? String
        drink = data["name"] as? String
        pictureUrl = data["pictureURL"] as? String
        if let coordinatesDict = data["coordinates"] as? [String : AnyObject] {
            coordinates = Coordinates(dict: coordinatesDict)
        } else {
            coordinates = nil
        }
        
    }
    
    func toDictionary() -> [String : AnyObject] {
        let dictionnary : [String : AnyObject]
        let coordinates : [String : AnyObject]
        coordinates = [
            "latitude": self.coordinates?.latitude,
            "longitude": self.coordinates?.longitude
            ] as [String : AnyObject]
        
        dictionnary = [
            "name" : self.drink ?? "",
            "coordinatess" : coordinates,
            "pictureURL" : self.pictureUrl ?? "",
            "date" : self.date ?? ""
            ] as [String : AnyObject]
        return dictionnary
    }
    
    init(date: String, drink: String, pictureUrl: String, coordinates: Coordinates) {
        self.id = nil
        self.date = date
        self.drink = drink
        self.pictureUrl = pictureUrl
        self.coordinates = coordinates
    }
    
}
