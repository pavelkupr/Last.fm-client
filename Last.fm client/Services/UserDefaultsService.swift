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
}
