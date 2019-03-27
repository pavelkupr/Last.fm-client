//
//  Artist.swift
//  Last.fm client
//
//  Created by student on 3/25/19.
//  Copyright © 2019 student. All rights reserved.
//

import SwiftyJSON

struct Artist {
    var name: String
    var playCount: String
    var listeners: String
    var info: String?
    var photoUrls = [ImageSize : String]()
    
    init(jsonArtist: JSON) throws {
        
        name = jsonArtist["name"].stringValue
        playCount = jsonArtist["playcount"].stringValue
        listeners = jsonArtist["listeners"].stringValue
        
        for i in 0..<jsonArtist["image"].count {
            if let size = ImageSize(rawValue: jsonArtist["image"][i]["size"].stringValue) {
                photoUrls[size] = jsonArtist["image"][i]["#text"].stringValue
            }
        }
    }
    
    init(jsonArtistWithInfo json: JSON) throws {
        
        let jsonArtist = json["artist"]
        name = jsonArtist["name"].stringValue
        playCount = jsonArtist["stats"]["playcount"].stringValue
        listeners = jsonArtist["stats"]["listeners"].stringValue
        info = jsonArtist["bio"]["content"].stringValue
        
        for i in 0..<jsonArtist["image"].count {
            if let size = ImageSize(rawValue: jsonArtist["image"][i]["size"].stringValue) {
                photoUrls[size] = jsonArtist["image"][i]["#text"].stringValue
            }
        }
    }
    
}
