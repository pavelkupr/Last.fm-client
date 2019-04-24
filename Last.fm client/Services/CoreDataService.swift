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
    
    func addFavoriteArtist(withArtist artist: Artist) {
        
        var props: [String: Any] = [
            "name": artist.name
        ]
        
        for (key, img) in artist.imageURLs ?? [:]  {
            switch key {
            case .small:
                props["smallImg"] = img
            case .medium:
                props["mediumImg"] = img
            case .large:
                props["largeImg"] = img
            case .extralarge:
                props["extralargeImg"] = img
            case .mega:
                props["megaImg"] = img
            }
        }
        
        if !isInFavoriteArtist(name: artist.name) {
            dataManager.addNewObject(withEntityName: "FavoriteArtist", withProperties: props)
        }
    }
    
    func addFavoriteTrack(withTrack track: Track) {
        
        var props: [String: Any] = [
            "name": track.name,
            "artistName": track.artistName
        ]
        
        for (key, img) in track.imageURLs ?? [:]  {
            switch key {
            case .small:
                props["smallImg"] = img
            case .medium:
                props["mediumImg"] = img
            case .large:
                props["largeImg"] = img
            case .extralarge:
                props["extralargeImg"] = img
            case .mega:
                props["megaImg"] = img
            }
        }
        
        if !isInFavoriteTrack(name: track.name, artist: track.artistName) {
            dataManager.addNewObject(withEntityName: "FavoriteTrack", withProperties: props)
        }
    }
    
    func removeFavoriteArtist(withArtist artist: Artist) {
        
        if let data = getFavoriteArtist(name: artist.name) {
            dataManager.deleteObject(withInstance: data)
        }
    }
    
    func removeFavoriteTrack(withTrack track: Track) {
        
        if let data = getFavoriteTrack(name: track.name, artist: track.artistName) {
            dataManager.deleteObject(withInstance: data)
        }
    }
    
    func getFavoriteArtistsClosure() -> ArtistSource {
        
        return { (closure: @escaping ([Artist], Error?) -> Void ) -> Void in
            
            guard let data = self.dataManager.loadData(withEntityName: "FavoriteArtist") as? [FavoriteArtist] else {
                fatalError("Can't cast data")
            }
            
            var artists = [Artist]()
            for index in 0..<data.count {
                let name = data[index].name!
                let urls = self.createPhotoUrls(small: data[index].smallImg,
                                                med: data[index].mediumImg,
                                                large: data[index].largeImg,
                                                extra: data[index].extralargeImg,
                                                mega: data[index].megaImg)
                artists.append(Artist(name: name, photoUrls: urls))
            }
            closure(artists, nil)
        }
    }
    
    func getFavoriteTracksClosure() -> TrackSource {
        
        return { (closure: @escaping ([Track], Error?) -> Void ) -> Void in
            
            guard let data = self.dataManager.loadData(withEntityName: "FavoriteTrack") as? [FavoriteTrack] else {
                fatalError("Can't cast data")
            }
            
            var tracks = [Track]()
            for index in 0..<data.count {
                let name = data[index].name!
                let artist = data[index].artistName!
                let urls = self.createPhotoUrls(small: data[index].smallImg,
                                                med: data[index].mediumImg,
                                                large: data[index].largeImg,
                                                extra: data[index].extralargeImg,
                                                mega: data[index].megaImg)
                tracks.append(Track(name: name, artist: artist, photoUrls: urls))
            }
            closure(tracks, nil)
        }
    }
    
    func isInFavoriteArtist(name: String) -> Bool {
        
        return getFavoriteArtist(name: name) != nil
    }
    
    func isInFavoriteTrack(name: String, artist: String) -> Bool {
        
        return getFavoriteTrack(name: name, artist: artist) != nil
    }
    
    private func getData(artist: String, track: String?) -> Rating? {
        guard let artistsRating = dataManager.loadData(withEntityName: "Rating")
            as? [Rating] else {
                fatalError("Can't cast objects")
        }
        
        return artistsRating.first {$0.artist == artist && $0.track == track}
    }
    
    private func getFavoriteArtist(name: String) -> FavoriteArtist? {
        guard let artists = dataManager.loadData(withEntityName: "FavoriteArtist")
            as? [FavoriteArtist] else {
                fatalError("Can't cast objects")
        }
        
        return artists.first{$0.name! == name}
    }
    
    private func getFavoriteTrack(name: String, artist: String) -> FavoriteTrack? {
        guard let artists = dataManager.loadData(withEntityName: "FavoriteTrack")
            as? [FavoriteTrack] else {
                fatalError("Can't cast objects")
        }
        
        return artists.first{$0.name! == name && $0.artistName! == artist}
    }
    
    private func createPhotoUrls(small: String?, med: String?, large: String?,
                                 extra: String?, mega: String?) -> [ImageSize:String] {
        var result = [ImageSize:String]()
        result[.small] = small ?? ""
        result[.medium] = med ?? ""
        result[.large] = large ?? ""
        result[.extralarge] = extra ?? ""
        result[.mega] = mega ?? ""
        
        return result
    }
}
