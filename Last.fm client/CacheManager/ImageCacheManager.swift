//
//  CacheManager.swift
//  Last.fm client
//
//  Created by student on 4/15/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class ImageCacheManager: CacheManager {
    
    typealias DataType = UIImage
    static let memoryCache = MemoryCache(capacity: 50, clearCapacity: 20)
    static let diskCache = DiskCache()
    
    func decode(_ data: Data) -> DataType {
        guard let image = UIImage(data: data) else {
            fatalError("Cant get image from data")
        }
        return image
    }
    
    func encode(_ object: DataType) -> Data {
        guard let pngData = UIImage.pngData(object)() else {
            fatalError("Cant get data from image")
        }
        return pngData
    }
    
}
