//
//  CustomTableViewCell.swift
//  Last.fm client
//
//  Created by Pavel on 4/8/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import SDWebImage

class CustomTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var photoImageView: RoundedImageView!
    @IBOutlet weak var mainInfoLabel: UILabel!
    @IBOutlet weak var bottomInfoLabel: UILabel!
    @IBOutlet weak var topInfoLabel: UILabel!

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
                photoImageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: nil)
            } else {
                photoImageView.image = placeholder
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if animated {
            photoImageView.highlightBorder(withColour: tintColor)
        }
    }
    
    // MARK: Private methods
    
    private func hideCell() {
        bottomInfoLabel.isHidden = true
        photoImageView.isHidden = true
        topInfoLabel.isHidden = true
    }
}
