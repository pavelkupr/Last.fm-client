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
    
    func saveCountry(name: String ) {
        UserDefaults.standard.set(name, forKey: "CountryName")
    }
    
    func getCurrCountry() -> String? {
        return UserDefaults.standard.string(forKey: "CountryName")
    }
    
    func saveGeoState(state: Bool ) {
        UserDefaults.standard.set(state, forKey: "GeoState")
    }
    
    func getGeoState() -> Bool {
        return UserDefaults.standard.bool(forKey: "GeoState")
    }
}
