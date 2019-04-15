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
    
    static var imageCash: [URL:UIImage] = [:]
    static var imageViewURLs: [UIImageView:URL] = [:]
    private let urlSession = URLSession(configuration: .ephemeral)
    
    func downloadImage(from url: URL, to imageView: UIImageView, placeholder: UIImage? = nil) {
        ImageLoader.imageViewURLs[imageView] = url
        
        if ImageLoader.imageCash[url] != nil {
            imageView.image = ImageLoader.imageCash[url]
            
        } else {
            imageView.image = placeholder
            
            getData(from: url) { data, response, error in
                if error != nil {
                    NSLog("Error: \(String(describing: error))")
                    
                } else if let data = data {
                    DispatchQueue.main.async() {
                        let image = UIImage(data: data)
                        ImageLoader.imageCash[url] = image
                        if ImageLoader.imageViewURLs[imageView] == url {
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
