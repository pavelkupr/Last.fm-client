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
    
    private let dataService = CoreDataService()
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
        
        //TODO: Replace by more optimized code
        
        let rating: Int16?
        
        if bottomInfoLabel.isHidden {
            rating=dataService.getRating(artist: mainInfoLabel.text!, track: nil)
        } else {
            rating=dataService.getRating(artist: bottomInfoLabel.text!, track:  mainInfoLabel.text!)
        }
        
        if let rating = rating {
            ratingControl.rating = rating
        } else {
            ratingControl.rating = 0
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        ratingControl.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if animated {
            photoImageView.highlightBorder(withColour: tintColor)
        }
    }
    
    // MARK: RatingControlDelegate
    func ratingDidChange(newRating: Int16) {
        if bottomInfoLabel.isHidden {
            dataService.addRating(withArtist: mainInfoLabel.text!, withTrack: nil, withRating: newRating)
        } else {
            dataService.addRating(withArtist: bottomInfoLabel.text!, withTrack:  mainInfoLabel.text!, withRating: newRating)
        }
    }
    
    // MARK: Private methods
    
    private func hideCell() {
        bottomInfoLabel.isHidden = true
        photoImageView.isHidden = true
        topInfoLabel.isHidden = true
    }
}
