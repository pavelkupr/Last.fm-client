//
//  DiskCache.swift
//  Last.fm client
//
//  Created by student on 4/15/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation

class DiskCache: Cache {
    
    typealias DataType = Data
    
    let path: String = {
        let dstPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        return (dstPath as NSString).appendingPathComponent("DiskCache")
    }()
    
    private let fileManager = FileManager()
    private let writeQueue: DispatchQueue = DispatchQueue(label: "DiskCacheQueue")
    
    func store(key: String, object: DataType) {
        writeQueue.async {
            
            if !self.fileManager.fileExists(atPath: self.path) {
                do {
                    try self.fileManager.createDirectory(atPath: self.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    NSLog("Error \(error)")
                }
            }
            
            let cacheFilePath = (self.path as NSString).appendingPathComponent(key)
            
            self.fileManager.createFile(atPath: cacheFilePath, contents: object, attributes: nil)
            
        }
    }
    
    func retrieve(key: String, completion: @escaping (DataType?) -> Void) {
        let filePath = (path as NSString).appendingPathComponent(key)
        let data = try? Data(contentsOf: URL(fileURLWithPath: filePath))
        completion(data)
    }
    
    func isOnCache(_ key: String) -> Bool {
        let filePath = (path as NSString).appendingPathComponent(key)
        return fileManager.fileExists(atPath: filePath)
    }
}
