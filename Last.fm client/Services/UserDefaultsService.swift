//
//  UserDefaultsService.swift
//  Last.fm client
//
//  Created by student on 4/25/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation

class UserDefaultsService {
    func saveSearchRequests(requests: [Storable]) {
        let strings = requests.map{$0.mainInfo}
        UserDefaults.standard.set(strings, forKey: "SearchRequests")
    }
    
    func getSearchRequests() -> [Storable]{
        return UserDefaults.standard.stringArray(forKey: "SearchRequests") ?? []
    }
    
    func saveCountry(location: Location ) {
        UserDefaults.standard.set(location.name, forKey: "CountryName")
        UserDefaults.standard.set(location.coord.latitude, forKey: "CountryLat")
        UserDefaults.standard.set(location.coord.longitude, forKey: "CountryLng")
    }
    
    func getCurrCountry() -> Location? {
        let name = UserDefaults.standard.string(forKey: "CountryName")
        let lat = UserDefaults.standard.double(forKey: "CountryLat")
        let lng = UserDefaults.standard.double(forKey: "CountryLng")
        
        if let name = name, lng != 0 || lat != 0 {
            return Location(name: name, lat: lat, lng: lng)
        }
        
        return nil
    }
    
    func saveGeoState(state: Bool ) {
        UserDefaults.standard.set(state, forKey: "GeoState")
    }
    
    func getGeoState() -> Bool {
        return UserDefaults.standard.bool(forKey: "GeoState")
    }
    
    func saveLocationState(state: Bool ) {
        UserDefaults.standard.set(state, forKey: "LocationState")
    }
    
    func getLocationState() -> Bool {
        return UserDefaults.standard.bool(forKey: "LocationState")
    }
}
