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
        guard let artistArray = jsonArtists["artists"]["artist"].array else {
            fatalError("Unexpected JSON parameters")
        }
        
        self.artists = try artistArray.map(Artist.init(jsonArtist:))
    }
    
    init(foundJSONArtists: JSON) throws {
        guard let artistsArray = foundJSONArtists["results"]["artistmatches"]["artist"].array else {
            fatalError("Unexpected JSON parameters")
        }
        
        self.artists = try artistsArray.map(Artist.init(jsonArtist:))
    }
    
}

struct Artist {
    var name: String
    var playCount: String
    var listeners: String
    var info: String?
    var photoUrls = [String : String]()
    
    init(jsonArtist: JSON) throws {
        name = jsonArtist["name"].stringValue
        playCount = jsonArtist["playcount"].stringValue
        listeners = jsonArtist["listeners"].stringValue
        
        for i in 0..<jsonArtist["image"].count {
            photoUrls[jsonArtist["image"][i]["size"].stringValue] = jsonArtist["image"][i]["#text"].stringValue
        }
    }
    
    init(jsonArtistWithInfo json: JSON) throws {
        let jsonArtist = json["artist"]
        
        name = jsonArtist["name"].stringValue
        playCount = jsonArtist["stats"]["playcount"].stringValue
        listeners = jsonArtist["stats"]["listeners"].stringValue
        info = jsonArtist["bio"]["content"].stringValue
        
        for i in 0..<jsonArtist["image"].count {
            photoUrls[jsonArtist["image"][i]["size"].stringValue] = jsonArtist["image"][i]["#text"].stringValue
        }
    }
    
}
