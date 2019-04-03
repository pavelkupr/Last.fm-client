//
//  Artist.swift
//  Last.fm client
//
//  Created by student on 3/25/19.
//  Copyright © 2019 student. All rights reserved.
//
// TODO: Remove SwiftyJSON
import SwiftyJSON

struct Artist {

    var name: String
    var playCount: String
    var listeners: String
    var info: String?
    var photoUrls = [ImageSize: String]()

    init(jsonArtist: JSON) throws {

        name = jsonArtist["name"].stringValue
        playCount = jsonArtist["playcount"].stringValue
        listeners = jsonArtist["listeners"].stringValue

        if let imagesInfo = jsonArtist["image"].array {
            for imageInfo in imagesInfo {
                if let size = ImageSize(rawValue: imageInfo["size"].stringValue) {
                    photoUrls[size] = imageInfo["#text"].stringValue
                }
            }
        }
    }

    init(jsonArtistWithInfo json: JSON) throws {

        let jsonArtist = json["artist"]
        name = jsonArtist["name"].stringValue
        playCount = jsonArtist["stats"]["playcount"].stringValue
        listeners = jsonArtist["stats"]["listeners"].stringValue
        info = jsonArtist["bio"]["content"].stringValue

        if let imagesInfo = jsonArtist["image"].array {
            for imageInfo in imagesInfo {
                if let size = ImageSize(rawValue: imageInfo["size"].stringValue) {
                    photoUrls[size] = imageInfo["#text"].stringValue
                }
            }
        }
    }

}
