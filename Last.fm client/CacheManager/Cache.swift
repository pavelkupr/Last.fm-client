//
//  Cache.swift
//  Last.fm client
//
//  Created by student on 4/15/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation

protocol Cache {
    
    func store<T: Cachable>(key: String, object: T, completion: (() -> Void)?)
    
    func retrieve<T: Cachable>(key: String, completion: @escaping (_ object: T?) -> Void)
    
}
