//
//  ArtistTableViewCell.swift
//  Last.fm client
//
//  Created by Pavel on 3/25/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import SDWebImage

class ArtistTableViewCell: UITableViewCell {

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

    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistName: UILabel!

    func fillCell(withArtist artist: Artist) {

        artistName.text = artist.name

        if let largeImg = artist.photoUrls[sizeDesc], let url = URL(string: largeImg) {
            artistImageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: nil)

        } else {
            artistImageView.image = placeholder
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
