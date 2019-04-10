//
//  Album.swift
//  Last.fm client
//
//  Created by student on 4/10/19.
//  Copyright © 2019 student. All rights reserved.
//

import SwiftyJSON

struct Album {

    var name: String
    var artistName: String
    var photoUrls = [ImageSize: String]()

    init(jsonAlbum: JSON) throws {

        name = jsonAlbum["title"].stringValue
        artistName = jsonAlbum["artist"].stringValue

        if let imagesInfo = jsonAlbum["image"].array {
            for imageInfo in imagesInfo {
                if let size = ImageSize(rawValue: imageInfo["size"].stringValue) {
                    photoUrls[size] = imageInfo["#text"].stringValue
                }
            }
        }
    }
}
