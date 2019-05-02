//
//  GoogleMapService.swift
//  Last.fm client
//
//  Created by student on 4/25/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation
import GoogleMaps
import SwiftyJSON

class GeoService {
    
    private let userDefaults = UserDefaultsService()
    private let apiService = APIService()
    
    private lazy var httpClient: HTTPClient = {
        guard let baseURL = Bundle.main.infoDictionary?["Countries_URL"] as? String else {
            fatalError("Can't find base URL")
        }
        
        return URLSessionHTTPClient(baseURL: baseURL)
    }()
    
    func getCountry(byCode code: String, closure: @escaping (CLLocationCoordinate2D, Error?) -> Void) {
        httpClient.get(urlAppend: code, contentType: .json) { data, error in
            if let jsonData = data as? JSON {
                guard let coord = jsonData["latlng"].array,
                let lat = coord[0].double, let lng = coord[1].double,
                let latMap = CLLocationDegrees(exactly: lat),
                let lngMap = CLLocationDegrees(exactly: lng) else {
                    fatalError("Unexpected JSON parameters")
                }
                
                let locCoord = CLLocationCoordinate2D(latitude: latMap,
                                                      longitude: lngMap)
                closure(locCoord, nil)
            }
        }
    }
    
    func getLocationRelatedTop() -> [TableViewInfo] {
        if userDefaults.getLocationState() {
            guard let location = userDefaults.getCurrCountry() else {
                fatalError("Location is empty")
            }
            
            return [TableViewInfo(data: [], navName: "Top Artists", dataSource: apiService.getTopArtistsClosure(byCountry: location.name)),
                    TableViewInfo(data: [], navName: "Top Tracks", dataSource: apiService.getTopTracksClosure(byCountry: location.name))]
        } else {
            return [TableViewInfo(data: [], navName: "Top Artists", dataSource: apiService.getTopArtistsClosure()),
                    TableViewInfo(data: [], navName: "Top Tracks", dataSource: apiService.getTopTracksClosure())]
        }
    }
    
    func getChartsHeaderWithCountryCode() -> String {
        if userDefaults.getLocationState(), let location = userDefaults.getCurrCountry(),
            let code = countriesCode.first(where: {$0.value == location.name})?.key {
            return "Charts" + " [" + code + "]"
        }
        return "Charts"
    }
}
