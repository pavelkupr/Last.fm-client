//
//  IntExtension.swift
//  Last.fm client
//
//  Created by student on 4/3/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation

extension Int {

    mutating func increment() -> Int {
        self += 1
        return self
    }
}
