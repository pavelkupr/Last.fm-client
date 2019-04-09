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
    var playCount: String?
    var listeners: String?
    var info: String?
    var photoUrls = [ImageSize: String]()
    var similar = [Artist]()
    var numInChart: Int?

    init(jsonArtist: JSON, numInChart: Int? = nil) throws {
        self.numInChart = numInChart
        name = jsonArtist["name"].stringValue

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

        if let similarInfo = jsonArtist["similar"]["artist"].array {
            for artistInfo in similarInfo {
                similar.append(try Artist(jsonArtist: artistInfo))
            }
        }

    }

}

extension Artist: Storable {
    var mainInfo: String {
        return name
    }

    var topInfo: String? {
        if let num = numInChart {
            return "Top "+String(num)
        }
        return nil
    }

    var bottomInfo: String? {
        return nil
    }

    var aboutInfo: String? {
        return info
    }

    var imageURLs: [ImageSize: String]? {
        return photoUrls
    }

}
