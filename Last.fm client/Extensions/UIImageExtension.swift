//
//  UIImageExtension.swift
//  Last.fm client
//
//  Created by student on 4/15/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

extension UIImage: Cachable {
    required public convenience init?(cachableData data: Data) {
        self.init(data: data)
    }
    func encode() -> Data? {
        
        let pngData = UIImage.pngData(self)
        return pngData()
    }
}
