//
//  CustomCollectionViewCell.swift
//  Last.fm client
//
//  Created by student on 4/8/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    @IBOutlet var imageView: RoundedImageView!
    @IBOutlet var mainInfo: UILabel!

    private let imageSize = ImageSize.large
    private lazy var placeholder: UIImage? = {
        if let placeholder = UIImage(named: "Placeholder") {
            return placeholder

        } else {
            NSLog("Can't find placeholder")
            return nil
        }
    }()

    func fillCell(withStorableData data: Storable) {
        mainInfo.text = data.mainInfo

        if let imgs = data.imageURLs, let img = imgs[imageSize], let url = URL(string: img) {
            imageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: nil)
        } else {
            imageView.image = placeholder
        }
    }
}
