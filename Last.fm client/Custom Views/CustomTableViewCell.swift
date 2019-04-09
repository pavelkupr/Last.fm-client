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
    
    private let heightForBigCell:CGFloat = 79.5
    private let heightForSmallCell:CGFloat = 29.5
    private let imageSize = ImageSize.large
    private lazy var placeholder: UIImage? = {
        if let placeholder = UIImage(named: "Placeholder") {
            return placeholder

        } else {
            NSLog("Can't find placeholder")
            return nil
        }
    }()

    @IBOutlet weak var photoImageView: RoundedImageView!
    @IBOutlet weak var mainInfoLabel: UILabel!
    @IBOutlet weak var bottomInfoLabel: UILabel!
    @IBOutlet weak var topInfoLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    func fillCell(withRecentInfo recent: String) {
        setRecentMode()
        mainInfoLabel.text = recent
    }

    func fillCell(withTrack track: Track, numInChart: Int? = nil) {

        if let top = numInChart {
            setTrackMode(withTop: true)
            topInfoLabel.text = "Top " + String(top)
        } else {
            setTrackMode(withTop: false)
        }

        mainInfoLabel.text = track.name
        bottomInfoLabel.text = "by " + track.artistName

        if let largeImg = track.photoUrls[imageSize], let url = URL(string: largeImg) {
            photoImageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: nil)

        } else {
            photoImageView.image = placeholder
        }
    }

    func fillCell(withArtist artist: Artist, numInChart: Int? = nil) {

        if let top = numInChart {
            setArtistMode(withTop: true)
            topInfoLabel.text = "Top " + String(top)
        } else {
            setArtistMode(withTop: false)
        }

        mainInfoLabel.text = artist.name

        if let largeImg = artist.photoUrls[imageSize], let url = URL(string: largeImg) {
            photoImageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: nil)

        } else {
            photoImageView.image = placeholder
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setArtistMode(withTop top: Bool) {
        stackView.alignment = .top
        heightConstraint.constant = heightForBigCell
        bottomInfoLabel.isHidden = true
        photoImageView.isHidden = false
        mainInfoLabel.isHidden = false
        topInfoLabel.isHidden = !top
    }

    private func setTrackMode(withTop top: Bool) {
        stackView.alignment = .top
        heightConstraint.constant = heightForBigCell
        bottomInfoLabel.isHidden = false
        photoImageView.isHidden = false
        mainInfoLabel.isHidden = false
        topInfoLabel.isHidden = !top
    }

    private func setRecentMode() {
        stackView.alignment = .center
        heightConstraint.constant = heightForSmallCell
        bottomInfoLabel.isHidden = true
        photoImageView.isHidden = true
        mainInfoLabel.isHidden = false
        topInfoLabel.isHidden = true
    }
}
