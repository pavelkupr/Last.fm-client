//
//  Cache.swift
//  Last.fm client
//
//  Created by student on 4/15/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation

protocol Cache {
    associatedtype DataType

    func store(key: String, object: DataType)

    func retrieve(key: String, completion: @escaping (_ object: DataType?) -> Void)

    func isOnCache(_ key: String) -> Bool
}
