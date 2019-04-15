//
//  CacheManager.swift
//  Last.fm client
//
//  Created by student on 4/15/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation

class CacheManager: Cache {
    
    private let memoryCache = MemoryCache()
    private let diskCache = DiskCache()
    
    func store<T : Cachable>(key: String, object: T, completion: (() -> Void)? = nil) {
        memoryCache.store(key: key, object: object) {
            
            self.diskCache.store(key: key, object: object, completion: {
                completion?()
            })
            
        }
    }
    
    func retrieve<T : Cachable>(key: String, completion: @escaping (T?) -> Void) {
        memoryCache.retrieve(key: key) { (object: T?) in
            if let object = object {
                completion(object)
                return
            }
            
            self.diskCache.retrieve(key: key, completion: { (object: T?) in
                if let object = object {
                    self.memoryCache.store(key: key, object: object, completion: nil)
                    completion(object)
                }
            })
            
        }
    }
    
}
