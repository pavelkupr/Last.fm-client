//
//  MemoryCache.swift
//  Last.fm client
//
//  Created by student on 4/15/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation

class MemoryCache: Cache {
    
    typealias DataType = AnyObject
    private let capacity: Int
    private let clearCapacity: Int
    private let cache = NSCache<AnyObject, AnyObject>()
    private var keyQueue = [String]()
    
    init(capacity: Int, clearCapacity: Int) {
        self.capacity = capacity
        self.clearCapacity = clearCapacity
    }
    
    func store(key: String, object: DataType) {
        keyQueue.append(key)
        cache.setObject(object as AnyObject, forKey: key as AnyObject)
        if keyQueue.count > capacity {
            clearCash()
        }
    }
    
    func retrieve(key: String, completion: @escaping (DataType?) -> Void) {
        let data = cache.object(forKey: key as AnyObject)
        completion(data)
        
    }
    
    func isOnCache(_ key: String) -> Bool {
        return cache.object(forKey: key as AnyObject) != nil
    }
    
    private func clearCash() {
        for _ in 0..<clearCapacity {
            cache.removeObject(forKey: keyQueue.remove(at: 0) as AnyObject)
        }
    }
}
