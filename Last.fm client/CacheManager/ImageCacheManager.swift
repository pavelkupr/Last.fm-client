//
//  CacheManager.swift
//  Last.fm client
//
//  Created by student on 4/15/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class ImageCacheManager: Cache {
    
    typealias DataType = UIImage
    private let memoryCache = MemoryCache()
    private let diskCache = DiskCache()
    
    func store(key: String, object: DataType) {
        memoryCache.store(key: key, object: object)
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
                    self.memoryCache.store(key: key, object: image)
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
    
    private func decode(_ data: Data) -> DataType {
        guard let image = UIImage(data: data) else {
            fatalError("Cant get image from data")
        }
        return image
    }
    
    private func encode(_ object: DataType) -> Data {
        guard let pngData = UIImage.pngData(object)() else {
            fatalError("Cant get data from image")
        }
        return pngData
    }
    
}
