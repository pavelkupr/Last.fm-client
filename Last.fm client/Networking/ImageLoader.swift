//
//  ImageLoader.swift
//  Last.fm client
//
//  Created by student on 4/15/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class ImageLoader {
    
    // MARK: Properties
    
    static var imageViewURLs: [UIImageView:String] = [:]
    private let urlSession = URLSession(configuration: .ephemeral)
    private let cache = ImageCacheManager()
    
    func downloadImage(from url: URL, to imageView: UIImageView, placeholder: UIImage? = nil) {
        guard let urlHash = url.createMD5() else {
            fatalError("Cant create hash")
        }
        ImageLoader.imageViewURLs[imageView] = urlHash
        
        if cache.isOnCache(urlHash) {
            cache.retrieve(key: urlHash) { image in
                    imageView.image = image
            }

        } else {
            imageView.image = placeholder
            
            getData(from: url) { data, response, error in
                if error != nil {
                    NSLog("Error: \(String(describing: error))")
                    
                } else if let data = data, let image = UIImage(data: data)  {
                    DispatchQueue.main.async() {
                        self.cache.store(key: urlHash, object: image)
                        if ImageLoader.imageViewURLs[imageView] == urlHash {
                            imageView.image = image
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Private Methods
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        urlSession.dataTask(with: url, completionHandler: completion).resume()
    }
    
}
