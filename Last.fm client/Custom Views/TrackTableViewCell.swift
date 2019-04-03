//
//  TrackTableViewCell.swift
//  Last.fm client
//
//  Created by student on 3/26/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import SDWebImage

class TrackTableViewCell: UITableViewCell {

    // MARK: Properties

    private let sizeDesc = ImageSize.large
    private lazy var placeholder: UIImage? = {
        if let placeholder = UIImage(named: "Placeholder") {
            return placeholder

        } else {
            NSLog("Can't find placeholder")
            return nil
        }
    }()

    @IBOutlet weak var trackImageView: RoundedImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var topInfo: UILabel!

    func fillCell(withTrack track: Track, numInChart: Int? = nil) {

        if let top = numInChart {
            topInfo.isHidden = false
            topInfo.text = "Top " + String(top)
        }

        trackName.text = track.name
        artistName.text = "by " + track.artistName

        if let largeImg = track.photoUrls[sizeDesc], let url = URL(string: largeImg) {
            trackImageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: nil)

        } else {
            trackImageView.image = placeholder
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
