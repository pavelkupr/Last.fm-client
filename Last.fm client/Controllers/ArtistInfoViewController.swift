//
//  ArtistInfoViewController.swift
//  Last.fm client
//
//  Created by student on 3/26/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import SDWebImage

class ArtistInfoViewController: UIViewController {

    // MARK: Properties

    private let apiService = APIService()
    var artist: Artist?

    private var placeholder: UIImage?

    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistInfo: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let placeholder = UIImage(named: "Placeholder") {
            self.placeholder = placeholder
        } else {
            NSLog("Can't find placeholder")
        }

        loadInfo()
    }

    // MARK: Private Methods

    private func loadInfo() {

        if let artist = artist {

            if artist.info == nil {
                artistName.text = artist.name

                if let largeImg = artist.photoUrls[.extralarge], let url = URL(string: largeImg) {
                    artistImageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: nil)

                } else {
                    artistImageView.image = placeholder
                }

                apiService.getArtistInfo(byName: artist.name) { data, error in

                    if let err = error {
                        NSLog("Error: \(err)")

                    } else if let data = data {
                        self.artistInfo.text = data.info!.replacingOccurrences(of: "<[^>]+>\\.? *",
                                                                               with: "\n",
                                                                               options: .regularExpression,
                                                                               range: nil)

                    }
                }
            }

        }
    }
}
