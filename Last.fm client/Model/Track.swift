//
//  Track.swift
//  Last.fm client
//
//  Created by Pavel on 3/26/19.
//  Copyright © 2019 student. All rights reserved.
//

import SwiftyJSON

struct Track {
    var name: String
    var artistName: String
    var playCount: String
    var listeners: String
    var photoUrls = [ImageSize : String]()
    
    init(jsonTrack: JSON) throws {
        
        name = jsonTrack["name"].stringValue
        playCount = jsonTrack["playcount"].stringValue
        listeners = jsonTrack["listeners"].stringValue
        artistName = jsonTrack["artist"]["name"].stringValue
        
        for i in 0..<jsonTrack["image"].count {
            if let size = ImageSize(rawValue: jsonTrack["image"][i]["size"].stringValue) {
                photoUrls[size] = jsonTrack["image"][i]["#text"].stringValue
            }
        }
    }
}
