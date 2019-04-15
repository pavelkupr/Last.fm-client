//
//  DiskCache.swift
//  Last.fm client
//
//  Created by student on 4/15/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation

class DiskCache: Cache {
    
    let path: String = {
        let dstPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        return (dstPath as NSString).appendingPathComponent("DiskCache")
    }()
    
    private let fileManager = FileManager()
    private let ioQueue: DispatchQueue = DispatchQueue(label: "DiskCacheIOQueue")
    
    func store<T : Cachable>(key: String, object: T, completion: (() -> Void)? = nil) {
        ioQueue.async {
            
            if !self.fileManager.fileExists(atPath: self.path) {
                do {
                    try self.fileManager.createDirectory(atPath: self.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    NSLog("Error \(error)")
                }
            }
            
            let cacheFilePath = (self.path as NSString).appendingPathComponent(key)
            
            self.fileManager.createFile(atPath: cacheFilePath, contents: object.encode(), attributes: nil)
            
        }
        
        completion?()
    }
    
    func retrieve<T : Cachable>(key: String, completion: @escaping (T?) -> Void) {
        let filePath = (path as NSString).appendingPathComponent(key)
        if let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) {
            completion(T.decode(data))
        } else {
            completion(nil)
        }
    }
    
}
