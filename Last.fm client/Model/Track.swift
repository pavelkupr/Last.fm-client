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
    var info: String?
    var photoUrls = [ImageSize: String]()

    init(jsonTrack: JSON) throws {

        name = jsonTrack["name"].stringValue
        playCount = jsonTrack["playcount"].stringValue
        listeners = jsonTrack["listeners"].stringValue
        artistName = jsonTrack["artist"]["name"].stringValue

        if let imagesInfo = jsonTrack["image"].array {
            for imageInfo in imagesInfo {
                if let size = ImageSize(rawValue: imageInfo["size"].stringValue) {
                    photoUrls[size] = imageInfo["#text"].stringValue
                }
            }
        }
    }
    
    init(jsonTrackWithInfo json: JSON) throws {
        let jsonTrack = json["track"]
        
        name = jsonTrack["name"].stringValue
        playCount = jsonTrack["playcount"].stringValue
        listeners = jsonTrack["listeners"].stringValue
        artistName = jsonTrack["artist"]["name"].stringValue
        info = jsonTrack["wiki"]["content"].stringValue
        if let imagesInfo = jsonTrack["image"].array {
            for imageInfo in imagesInfo {
                if let size = ImageSize(rawValue: imageInfo["size"].stringValue) {
                    photoUrls[size] = imageInfo["#text"].stringValue
                }
            }
        }
    }
    
    init(foundJsonTrack: JSON) throws {
        
        name = foundJsonTrack["name"].stringValue
        playCount = foundJsonTrack["playcount"].stringValue
        listeners = foundJsonTrack["listeners"].stringValue
        artistName = foundJsonTrack["artist"].stringValue
        
        if let imagesInfo = foundJsonTrack["image"].array {
            for imageInfo in imagesInfo {
                if let size = ImageSize(rawValue: imageInfo["size"].stringValue) {
                    photoUrls[size] = imageInfo["#text"].stringValue
                }
            }
        }
    }
}
