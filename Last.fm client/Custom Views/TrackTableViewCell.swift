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

    @IBOutlet weak var trackImageView: CircleImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    func fillCell(withArtist track: Track, withPlaceholder placeholder: UIImage?, withImageSizeDesc sizeDesc: ImageSize = .large) {
        
        trackName.text = track.name
        artistName.text = track.artistName
        
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
