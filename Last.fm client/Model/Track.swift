//
//  Track.swift
//  Last.fm client
//
//  Created by Pavel on 3/26/19.
//  Copyright © 2019 student. All rights reserved.
//

import SwiftyJSON

struct TracksResponse {
    let tracks: [Track]
    
    init(jsonTracks: JSON) throws {
        guard let tracksArray = jsonTracks["tracks"]["track"].array else {
            fatalError("Unexpected JSON parameters")
        }
        
        self.tracks = try tracksArray.map(Track.init(jsonTrack:))
    }
}

struct Track {
    var name: String
    var artistName: String
    var playCount: String
    var listeners: String
    var photoUrls = [String : String]()
    
    init(jsonTrack: JSON) throws {
        name = jsonTrack["name"].stringValue
        playCount = jsonTrack["playcount"].stringValue
        listeners = jsonTrack["listeners"].stringValue
        artistName = jsonTrack["artist"]["name"].stringValue
        
        for i in 0..<jsonTrack["image"].count {
            photoUrls[jsonTrack["image"][i]["size"].stringValue] = jsonTrack["image"][i]["#text"].stringValue
        }
    }
}
