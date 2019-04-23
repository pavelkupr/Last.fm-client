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

    init(name: String, photoUrls: [ImageSize: String]) {
        self.name = name
        self.photoUrls = photoUrls
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

    var imageURLs: [ImageSize: String]? {
        return photoUrls
    }
    
    var rating: Int16? {
        get{
            let dataService = CoreDataService()
            return dataService.getRating(artist: name, track: nil) ?? 0
        }
        set{
            if let value = newValue {
                let dataService = CoreDataService()
                dataService.addRating(withArtist: name, withTrack: nil, withRating: value)
            }
        }
    }
    
    var isFavorite: Bool? {
        get {
            let dataService = CoreDataService()
            return dataService.isInFavoriteArtist(name: self.name)
        }
    }
    
    func getAddidtionalInfo(closure: @escaping (AdditionalInfo) -> ()) {
        let apiService = APIService()
        var additional = AdditionalInfo()
        apiService.getArtistInfo(byName: name) { data, error in
            
            if let err = error {
                NSLog("Error: \(err)")
                
            } else if let data = data {
                additional.aboutInfo = data.info == "" ? nil : data.info
                additional.similar = data.similar.isEmpty ? nil : data.similar
                closure(additional)
            }
        }
    }
    
    func addToFavorite() {
        let dataService = CoreDataService()
        dataService.addFavoriteArtist(withArtist: self)
    }
    
    func removeFromFavorite() {
        let dataService = CoreDataService()
        dataService.removeFavoriteArtist(withArtist: self)
    }
}
