//
//  ServiceModel.swift
//  Last.fm client
//
//  Created by Pavel on 3/25/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation
import SwiftyJSON

enum APIMethod: String {
    case topArtists = "chart.gettopartists"
    case topTracks = "chart.gettoptracks"
    case searchArtists = "artist.search"
    case searchTracks = "track.search"
    case artistInfo = "artist.getinfo"
}

enum Format: String {
    case json
}

class ServiceModel {
    
    // MARK: Properties
    
    private lazy var httpClient: HTTPClient = {
        guard let baseURL = Bundle.main.infoDictionary?["MY_BASE_URL"] as? String else {
            fatalError("Can't find base URL")
        }
        
        return URLSessionHTTPClient(baseURL: baseURL)
    }()
    
    private lazy var apiKey: String = {
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else {
            fatalError("Can't find API key")
        }
        
        return apiKey
    }()
    
    func getTopArtists(onPage page: Int, withLimit limit: Int, closure: @escaping ([Artist], Error?)->Void ) {
        
        let params = [
            "method":APIMethod.topArtists.rawValue,
            "api_key":apiKey,
            "format":Format.json.rawValue,
            "page": String(page),
            "limit": String(limit)
        ]
        
        httpClient.get(parameters: params, contentType: .json) {
            data, error in
            
            guard error == nil else {
                closure([], error)
                return
            }
            
            if let jsonData = data as? JSON {
                do {
                    let artistsResponse = try ArtistsResponse(jsonArtists: jsonData)
                    closure(artistsResponse.artists, nil)
                    
                } catch let parseError as NSError {
                    print( "JSONSerialization error: \(parseError.localizedDescription)\n")
                }
            }
        }
    }
    
    func searchArtists(byName name: String, onPage page: Int, withLimit limit: Int, closure: @escaping ([Artist], Error?)->Void ) {
        
        let params = [
            "method":APIMethod.searchArtists.rawValue,
            "api_key":apiKey,
            "format":Format.json.rawValue,
            "artist":name,
            "page": String(page),
            "limit": String(limit)
        ]
        
        httpClient.get(parameters: params, contentType: .json) {
            data, error in
            
            guard error == nil else {
                closure([], error)
                return
            }
            
            if let jsonData = data as? JSON {
                do {
                    let artistsResponse = try ArtistsResponse(foundJSONArtists: jsonData)
                    closure(artistsResponse.artists, nil)
                    
                } catch let parseError as NSError {
                    print( "JSONSerialization error: \(parseError.localizedDescription)\n")
                }
            }
        }
    }
    
    func getArtistInfo(byName name: String, closure: @escaping (Artist?, Error?)
        -> Void){
        
        let params = [
            "method":APIMethod.artistInfo.rawValue,
            "api_key":apiKey,
            "format":Format.json.rawValue,
            "artist":name
        ]
        
        httpClient.get(parameters: params, contentType: .json) {
            data, error in
            
            guard error == nil else {
                closure(nil, error)
                return
            }
            
            if let jsonData = data as? JSON {
                do {
                    let artistResponse = try Artist( jsonArtistWithInfo: jsonData)
                    closure(artistResponse, nil)
                    
                } catch let parseError as NSError {
                    print( "JSONSerialization error: \(parseError.localizedDescription)\n")
                }
            }
        }
        
    }
    
    func getTopTracks(onPage page: Int, withLimit limit: Int, closure: @escaping ([Track], Error?)->Void ) {
        
        let params = [
            "method":APIMethod.topTracks.rawValue,
            "api_key":apiKey,
            "format":Format.json.rawValue,
            "page": String(page),
            "limit": String(limit)
        ]
        
        httpClient.get(parameters: params, contentType: .json) {
            data, error in
            
            guard error == nil else {
                closure([], error)
                return
            }
            
            if let jsonData = data as? JSON {
                do {
                    let tracksResponse = try TracksResponse(jsonTracks: jsonData)
                    closure(tracksResponse.tracks, nil)
                    
                } catch let parseError as NSError {
                    print( "JSONSerialization error: \(parseError.localizedDescription)\n")
                }
            }
        }
    }
    
    func searchTracks(byName name: String, onPage page: Int, withLimit limit: Int, closure: @escaping ([Track], Error?)->Void ) {
        
        let params = [
            "method":APIMethod.searchTracks.rawValue,
            "api_key":apiKey,
            "format":Format.json.rawValue,
            "track":name,
            "page": String(page),
            "limit": String(limit)
        ]
        
        httpClient.get(parameters: params, contentType: .json) {
            data, error in
            
            guard error == nil else {
                closure([], error)
                return
            }
            
            if let jsonData = data as? JSON {
                do {
                    let tracksResponse = try TracksResponse(foundJSONTracks: jsonData)
                    closure(tracksResponse.tracks, nil)
                    
                } catch let parseError as NSError {
                    print( "JSONSerialization error: \(parseError.localizedDescription)\n")
                }
            }
        }
    }
    
}
