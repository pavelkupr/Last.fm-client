//
//  CustomCollectionViewCell.swift
//  Last.fm client
//
//  Created by student on 4/8/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    private let imageSize = ImageSize.large
    private lazy var placeholder: UIImage? = {
        if let placeholder = UIImage(named: "Placeholder") {
            return placeholder
            
        } else {
            NSLog("Can't find placeholder")
            return nil
        }
    }()
    
    @IBOutlet var imageView: RoundedImageView!
    @IBOutlet var mainInfo: UILabel!
    
    func fillCell(withArtist artist: Artist) {
        
        mainInfo.text = artist.name
        
        if let largeImg = artist.photoUrls[imageSize], let url = URL(string: largeImg) {
            imageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: nil)
            
        } else {
            imageView.image = placeholder
        }
    }
}
