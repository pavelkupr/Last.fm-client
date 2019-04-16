//
//  CacheManager.swift
//  Last.fm client
//
//  Created by student on 4/16/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation

protocol CacheManager: Cache {
    
    var memoryCache: MemoryCache { get }
    var diskCache: DiskCache { get }
    
    func decode(_ data: Data) -> DataType
    
    func encode(_ object: DataType) -> Data
    
}

extension CacheManager {
    
    func store(key: String, object: DataType) {
        memoryCache.store(key: key, object: object as MemoryCache.DataType)
        let data = self.encode(object)
        self.diskCache.store(key: key, object: data)
    }
    
    func retrieve(key: String, completion: @escaping (DataType?) -> Void) {
        memoryCache.retrieve(key: key) { data in
            if let image = data as? DataType {
                completion(image)
                return
            }
            
            self.diskCache.retrieve(key: key, completion: { data in
                if let data = data {
                    let image = self.decode(data)
                    self.memoryCache.store(key: key, object: image as MemoryCache.DataType)
                    completion(image)
                } else {
                    completion(nil)
                }
            })
            
        }
    }
    
    func isOnCache(_ key: String) -> Bool {
        return diskCache.isOnCache(key)
    }
}
