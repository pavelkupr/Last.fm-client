//
//  APIService.swift
//  Last.fm client
//
//  Created by Pavel on 3/25/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias ArtistSource = ((_ closure: @escaping ([Artist], Error?) -> Void ) -> Void)
typealias TrackSource = ((_ closure: @escaping ([Track], Error?) -> Void ) -> Void)

enum Format: String {
    case json
}

enum ImageSize: String {
    case small, medium, large, extralarge, mega
}

class APIService {

    private enum APIMethod: String {
        case topArtists = "chart.gettopartists"
        case topTracks = "chart.gettoptracks"
        case searchArtists = "artist.search"
        case searchTracks = "track.search"
        case artistInfo = "artist.getinfo"
        case trackInfo = "track.getinfo"
    }
    
    // MARK: Properties

    let itemsPerPage = 50

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

    func getTopArtistsClosure(withStartPage startPage: Int = 1) -> ArtistSource {
        var isEnd = false
        var isWorking = false
        var pageCounter = startPage
        var topCounter = 0

        return { (closure: @escaping ([Artist], Error?) -> Void ) -> Void in
            guard !isEnd else {
                closure([], NSError(domain: "There isn't data", code: 404, userInfo: nil))
                return
            }
            guard !isWorking else {
                closure([], NSError(domain: "Can't perform many requests", code: 400, userInfo: nil))
                return
            }
            isWorking = true

            let params = [
                "method": APIMethod.topArtists.rawValue,
                "api_key": self.apiKey,
                "format": Format.json.rawValue,
                "page": String(pageCounter),
                "limit": String(self.itemsPerPage)
            ]

            self.httpClient.get(parameters: params, contentType: .json) { data, error in
                var artists: [Artist]
                guard error == nil else {
                    closure([], error)
                    return
                }

                if let jsonData = data as? JSON {
                    do {
                        guard var artistArray = jsonData["artists"]["artist"].array else {
                            fatalError("Unexpected JSON parameters")
                        }
                        artistArray = self.apiSecondPageBugFix(pageCounter, artistArray)
                        artists = try artistArray.map {try Artist(jsonArtist: $0, numInChart: topCounter.increment())}

                        if artists.count == 0 {
                            isEnd = true
                            closure([], NSError(domain: "There isn't data", code: 404, userInfo: nil))
                            return
                        }
                        closure(artists, nil)
                        pageCounter += 1
                        isWorking = false

                    } catch let parseError as NSError {
                        print( "JSONSerialization error: \(parseError.localizedDescription)\n")
                    }
                }
            }
        }
    }

    func getSearchArtistsClosure(byName name: String, withStartPage startPage: Int = 1) -> ArtistSource {
        var isEnd = false
        var isWorking = false
        var pageCounter = startPage

        return { (closure: @escaping ([Artist], Error?) -> Void ) -> Void in

            guard !isEnd else {
                closure([], NSError(domain: "There isn't data", code: 404, userInfo: nil))
                return
            }
            guard !isWorking else {
                closure([], NSError(domain: "Can't perform many requests", code: 400, userInfo: nil))
                return
            }
            isWorking = true
            
            let params = [
                "method": APIMethod.searchArtists.rawValue,
                "api_key": self.apiKey,
                "format": Format.json.rawValue,
                "artist": name,
                "page": String(pageCounter),
                "limit": String(self.itemsPerPage)
            ]

            self.httpClient.get(parameters: params, contentType: .json) { data, error in
                var artists: [Artist]
                guard error == nil else {
                    closure([], error)
                    return
                }

                if let jsonData = data as? JSON {
                    do {
                        guard let artistsArray = jsonData["results"]["artistmatches"]["artist"].array else {
                            fatalError("Unexpected JSON parameters")
                        }
                        artists = try artistsArray.map {try Artist(jsonArtist: $0)}

                        if artists.count == 0 {
                            isEnd = true
                            closure([], NSError(domain: "There isn't data", code: 404, userInfo: nil))
                            return
                        }
                        closure(artists, nil)
                        pageCounter += 1
                        isWorking = false

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

    func getTopTracksClosure(withStartPage startPage: Int = 1) -> TrackSource {
        var isEnd = false
        var pageCounter = startPage
        var isWorking = false
        var topCounter = 0

        return { (closure: @escaping ([Track], Error?) -> Void ) -> Void in

            guard !isEnd else {
                closure([], NSError(domain: "There isn't data", code: 404, userInfo: nil))
                return
            }
            guard !isWorking else {
                closure([], NSError(domain: "Can't perform many requests", code: 400, userInfo: nil))
                return
            }
            isWorking = true
            
            let params = [
                "method": APIMethod.topTracks.rawValue,
                "api_key": self.apiKey,
                "format": Format.json.rawValue,
                "page": String(pageCounter),
                "limit": String(self.itemsPerPage)
            ]

            self.httpClient.get(parameters: params, contentType: .json) { data, error in
                var tracks: [Track]
                guard error == nil else {
                    closure([], error)
                    return
                }

                if let jsonData = data as? JSON {
                    do {
                        guard let tracksArray = jsonData["tracks"]["track"].array else {
                            fatalError("Unexpected JSON parameters")
                        }
                        tracks = try tracksArray.map {try Track(jsonTrack: $0, numInChart: topCounter.increment())}

                        if tracks.count == 0 {
                            isEnd = true
                            closure([], NSError(domain: "There isn't data", code: 404, userInfo: nil))
                            return
                        }
                        closure(tracks, nil)
                        pageCounter += 1
                        isWorking = false

                    } catch let parseError as NSError {
                        print( "JSONSerialization error: \(parseError.localizedDescription)\n")
                    }
                }
            }
        }
    }

    func getSearchTracksClosure(byName name: String, withStartPage startPage: Int = 1) -> TrackSource {
        var isEnd = false
        var isWorking = false
        var pageCounter = startPage

        return { (closure: @escaping ([Track], Error?) -> Void ) -> Void in

            guard !isEnd else {
                closure([], NSError(domain: "There isn't data", code: 404, userInfo: nil))
                return
            }
            guard !isWorking else {
                closure([], NSError(domain: "Can't perform many requests", code: 400, userInfo: nil))
                return
            }
            isWorking = true
            
            let params = [
                "method": APIMethod.searchTracks.rawValue,
                "api_key": self.apiKey,
                "format": Format.json.rawValue,
                "track": name,
                "page": String(pageCounter),
                "limit": String(self.itemsPerPage)
            ]

            self.httpClient.get(parameters: params, contentType: .json) { data, error in
                var tracks: [Track]
                guard error == nil else {
                    closure([], error)
                    return
                }

                if let jsonData = data as? JSON {
                    do {
                        guard var tracksArray = jsonData["results"]["trackmatches"]["track"].array else {
                            fatalError("Unexpected JSON parameters")
                        }
                        tracksArray = self.apiSecondPageBugFix(pageCounter, tracksArray)
                        tracks = try tracksArray.map {try Track(foundJsonTrack: $0)}

                        if tracks.count == 0 {
                            isEnd = true
                            closure([], NSError(domain: "There isn't data", code: 404, userInfo: nil))
                            return
                        }
                        closure(tracks, nil)
                        pageCounter += 1
                        isWorking = false

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

    // MARK: Private Methods

    private func apiSecondPageBugFix(_ page: Int, _ data: [JSON]) -> [JSON] {
        if page == 2 {
            return Array(data.suffix(itemsPerPage))
        } else {
            return data
        }
    }

}
