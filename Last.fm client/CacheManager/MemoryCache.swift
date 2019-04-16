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
    private static let cache = NSCache<AnyObject, AnyObject>()
    private static let capacity = 50
    private static var keyQueue = [String]()
    
    func store(key: String, object: DataType) {
        MemoryCache.keyQueue.append(key)
        MemoryCache.cache.setObject(object as AnyObject, forKey: key as AnyObject)
        if MemoryCache.keyQueue.count > MemoryCache.capacity {
            deleteFirstKey()
        }
    }
    
    func retrieve(key: String, completion: @escaping (DataType?) -> Void) {
        let data = MemoryCache.cache.object(forKey: key as AnyObject)
        completion(data)
        
    }
    
    func isOnCache(_ key: String) -> Bool {
        return MemoryCache.cache.object(forKey: key as AnyObject) != nil
    }
    
    private func deleteFirstKey() {
        MemoryCache.cache.removeObject(forKey: MemoryCache.keyQueue.remove(at: 0) as AnyObject)
    }
}
