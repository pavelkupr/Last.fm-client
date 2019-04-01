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
    case trackInfo = "track.getinfo"
}

enum Format: String {
    case json
}

enum ImageSize: String {
    case small, medium, large, extralarge, mega
}

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

struct TracksResponse {
    let tracks: [Track]

    init(jsonTracks: JSON) throws {

        guard let tracksArray = jsonTracks["tracks"]["track"].array else {
            fatalError("Unexpected JSON parameters")
        }

        self.tracks = try tracksArray.map(Track.init(jsonTrack:))
    }

    init(foundJSONTracks: JSON) throws {

        guard let tracksArray = foundJSONTracks["results"]["trackmatches"]["track"].array else {
            fatalError("Unexpected JSON parameters")
        }

        self.tracks = try tracksArray.map(Track.init(foundJsonTrack:))
    }

}

class ServiceModel {

    // MARK: Properties

    private let itemsPerPage = 50

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

    // MARK: Public Methods

    func getTopArtistsClosure() -> (Int, @escaping ([Artist], Error?) -> Void ) -> Void {

        return { (page: Int, closure: @escaping ([Artist], Error?) -> Void ) -> Void in
            let params = [
                "method": APIMethod.topArtists.rawValue,
                "api_key": self.apiKey,
                "format": Format.json.rawValue,
                "page": String(page),
                "limit": String(self.itemsPerPage)
            ]

            self.httpClient.get(parameters: params, contentType: .json) { data, error in

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
    }

    func getSearchArtistsClosure(byName name: String) -> (Int, @escaping ([Artist], Error?) -> Void ) -> Void {

        return { (page: Int, closure: @escaping ([Artist], Error?) -> Void ) -> Void in
            let params = [
                "method": APIMethod.searchArtists.rawValue,
                "api_key": self.apiKey,
                "format": Format.json.rawValue,
                "artist": name,
                "page": String(page),
                "limit": String(self.itemsPerPage)
            ]

            self.httpClient.get(parameters: params, contentType: .json) { data, error in

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
    }

    func getArtistInfo(byName name: String, closure: @escaping (Artist?, Error?)
        -> Void) {

        let params = [
            "method": APIMethod.artistInfo.rawValue,
            "api_key": apiKey,
            "format": Format.json.rawValue,
            "artist": name
        ]

        httpClient.get(parameters: params, contentType: .json) { data, error in

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

    func getTopTracksClosure() -> (Int, @escaping ([Track], Error?) -> Void) -> Void {

        return { (page: Int, closure: @escaping ([Track], Error?) -> Void ) -> Void in
            let params = [
                "method": APIMethod.topTracks.rawValue,
                "api_key": self.apiKey,
                "format": Format.json.rawValue,
                "page": String(page),
                "limit": String(self.itemsPerPage)
            ]
            self.httpClient.get(parameters: params, contentType: .json) { data, error in

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
    }

    func getSearchTracksClosure(byName name: String) -> (Int, @escaping ([Track], Error?) -> Void ) -> Void {

        return { (page: Int, closure: @escaping ([Track], Error?) -> Void ) -> Void in
            let params = [
                "method": APIMethod.searchTracks.rawValue,
                "api_key": self.apiKey,
                "format": Format.json.rawValue,
                "track": name,
                "page": String(page),
                "limit": String(self.itemsPerPage)
            ]

            self.httpClient.get(parameters: params, contentType: .json) { data, error in

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

    func getTrackInfo(byTrackName trackName: String, byArtistName artistName: String,
                      closure: @escaping (Track?, Error?) -> Void) {

        let params = [
            "method": APIMethod.trackInfo.rawValue,
            "api_key": apiKey,
            "format": Format.json.rawValue,
            "artist": artistName,
            "track": trackName
        ]

        httpClient.get(parameters: params, contentType: .json) { data, error in

            guard error == nil else {
                closure(nil, error)
                return
            }

            if let jsonData = data as? JSON {
                do {
                    let trackResponse = try Track(jsonTrackWithInfo: jsonData)
                    closure(trackResponse, nil)

                } catch let parseError as NSError {
                    print( "JSONSerialization error: \(parseError.localizedDescription)\n")
                }
            }
        }

    }
}
