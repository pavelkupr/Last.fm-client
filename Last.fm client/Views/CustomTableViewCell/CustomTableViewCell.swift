//
//  CustomTableViewCell.swift
//  Last.fm client
//
//  Created by Pavel on 4/8/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell, RatingControlDelegate {
    
    // MARK: Properties
    @IBOutlet weak var photoImageView: RoundedImageView!
    @IBOutlet weak var mainInfoLabel: UILabel!
    @IBOutlet weak var bottomInfoLabel: UILabel!
    @IBOutlet weak var topInfoLabel: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!
    
    @IBOutlet weak var likeButton: FavoriteButton!
    private var data: Storable?
    private let imageLoader = ImageLoader()
    private let imageSize = ImageSize.large
    private lazy var placeholder: UIImage? = {
        if let placeholder = UIImage(named: "Placeholder") {
            return placeholder

        } else {
            NSLog("Can't find placeholder")
            return nil
        }
    }()

    func fillCell(withStorableData data: Storable, isWithImg: Bool) {
        hideCell()
        self.data = data
        mainInfoLabel.text = data.mainInfo

        if let top = data.topInfo {
            topInfoLabel.isHidden = false
            topInfoLabel.text = top
        }

        if let bottom = data.bottomInfo {
            bottomInfoLabel.isHidden = false
            bottomInfoLabel.text = bottom
        }

        if isWithImg {
            photoImageView.isHidden = false
            if let imgs = data.imageURLs, let img = imgs[imageSize], let url = URL(string: img) {
                imageLoader.downloadImage(from: url, to: photoImageView, placeholder: placeholder)
            } else {
                photoImageView.image = placeholder
            }
        }
        
        if let rating = data.rating {
            ratingControl.isHidden = false
            ratingControl.rating = rating
        }
        
        if let isFavorite = data.isFavorite {
            likeButton.isHidden = false
            likeButton.button.isSelected = isFavorite
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        ratingControl.delegate = self
        likeButton.button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if animated {
            photoImageView.highlightBorder(withColour: tintColor)
        }
    }
    
    // MARK: RatingControlDelegate
    
    func ratingDidChange(newRating: Int16) {
        data?.rating = newRating
    }
    
    // MARK: Private methods
    
    private func hideCell() {
        bottomInfoLabel.isHidden = true
        photoImageView.isHidden = true
        topInfoLabel.isHidden = true
        ratingControl.isHidden = true
        likeButton.isHidden = true
    }
    
    @objc private func buttonTapped(button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            data?.addToFavorite()
        } else {
            data?.removeFromFavorite()
        }
    }
}
