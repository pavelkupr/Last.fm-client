//
//  Cachable.swift
//  Last.fm client
//
//  Created by student on 4/15/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation

protocol Cachable {
    //associatedtype CacheType: Cachable
    
    //static func decode(_ data: Data) -> CacheType?
    
    init(cachableData data: Data)
    
    func encode() -> Data?
}
