//
//  CacheManager.swift
//  Last.fm client
//
//  Created by student on 4/16/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation

protocol CacheManager: Cache {
    
    static var memoryCache: MemoryCache { get }
    static var diskCache: DiskCache { get }
    
    func decode(_ data: Data) -> DataType
    
    func encode(_ object: DataType) -> Data
    
}

extension CacheManager {
    
    func store(key: String, object: DataType) {
        Self.memoryCache.store(key: key, object: object as MemoryCache.DataType)
        let data = self.encode(object)
        Self.diskCache.store(key: key, object: data)
    }
    
    func retrieve(key: String, completion: @escaping (DataType?) -> Void) {
        Self.memoryCache.retrieve(key: key) { data in
            if let object = data as? DataType {
                completion(object)
                return
            }
            
            Self.diskCache.retrieve(key: key, completion: { data in
                if let data = data {
                    let object = self.decode(data)
                    Self.memoryCache.store(key: key, object: object as MemoryCache.DataType)
                    completion(object)
                } else {
                    completion(nil)
                }
            })
            
        }
    }
    
    func isOnCache(_ key: String) -> Bool {
        return Self.diskCache.isOnCache(key)
    }
}
