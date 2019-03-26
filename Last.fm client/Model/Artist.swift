//
//  Artist.swift
//  Last.fm client
//
//  Created by student on 3/25/19.
//  Copyright © 2019 student. All rights reserved.
//

import SwiftyJSON

struct ArtistsResponse {
    let artists: [Artist]
    
    init(jsonArtists: JSON) throws {
        guard let jsonArtist = jsonArtists["artists"]["artist"].array else {
            fatalError("Unexpected JSON parameters")
        }
        
        self.artists = try jsonArtist.map(Artist.init(jsonArtist:))
    }
}

struct Artist {
    var name: String
    var playCount: String
    var listeners: String
    var photoUrls = [String : String]()
    
    init(jsonArtist: JSON) throws {
        name = jsonArtist["name"].stringValue
        playCount = jsonArtist["playcount"].stringValue
        listeners = jsonArtist["listeners"].stringValue
        for i in 0..<jsonArtist["image"].count {
            photoUrls[jsonArtist["image"][i]["size"].stringValue] = jsonArtist["image"][i]["#text"].stringValue
        }
    }
}
