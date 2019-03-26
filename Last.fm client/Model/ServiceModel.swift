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
}

enum Format: String {
    case json
}

class ServiceModel {
    
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
    
    func getArtists(closure: @escaping ([Artist], Error?)->Void ) {
        
        let params = [
            "method":APIMethod.topArtists.rawValue,
            "api_key":apiKey,
            "format":Format.json.rawValue
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
}
