//
//  Storable.swift
//  Last.fm client
//
//  Created by student on 4/9/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation

protocol Storable {
    
    var mainInfo: String { get }
    var topInfo: String? { get }
    var bottomInfo: String? { get }
    var imageURLs: [ImageSize: String]? { get }
    var rating: Int16? { get set }
    
    func getAddidtionalInfo(closure: @escaping (AdditionalInfo) -> ())
}

struct AdditionalInfo {
    var aboutInfo: String?
    var similar: [Storable]?
    var parent: Storable?
}
