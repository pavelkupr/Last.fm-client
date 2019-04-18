//
//  CoreDataService.swift
//  Last.fm client
//
//  Created by student on 4/18/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation
class CoreDataService {
    
    private let dataManager = CoreDataManager.instance
    
    func addRating(withArtist artist: String, withTrack track: String?, withRating rating: Int16) {
        
        var props: [String: Any] = [
            "artist": artist,
            "rating": rating
        ]
        
        if let track = track {
            props["track"] = track
        }
        if let data = getData(artist: artist, track: track) {
            dataManager.editObject(withInstance: data, withProperties: props)
            
        } else {
            dataManager.addNewObject(withEntityName: "Rating", withProperties: props)
        }
    }
    
    func getRating(artist: String, track: String?) -> Int16? {
        guard let artistsRating = dataManager.loadData(withEntityName: "Rating")
            as? [Rating] else {
                fatalError("Can't cast objects")
        }
        let ratingInfo = artistsRating.first {$0.artist == artist && $0.track == track}
        
        return ratingInfo?.rating
    }
    
    private func getData(artist: String, track: String?) -> Rating? {
        guard let artistsRating = dataManager.loadData(withEntityName: "Rating")
            as? [Rating] else {
                fatalError("Can't cast objects")
        }
        
        return artistsRating.first {$0.artist == artist && $0.track == track}
    }
}
