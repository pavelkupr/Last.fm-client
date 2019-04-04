//
//  TrackInfoViewController.swift
//  Last.fm client
//
//  Created by student on 4/1/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class TrackInfoViewController: UIViewController {

    private let apiService = APIService()
    private var placeholder: UIImage?
    var track: Track?

    @IBOutlet weak var trackImageView: RoundedImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackInfo: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

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

        if let track = track {

            if track.info == nil {
                artistName.text = "by "+track.artistName
                trackName.text = track.name

                if let largeImg = track.photoUrls[.extralarge], let url = URL(string: largeImg) {
                    trackImageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: nil)

                } else {
                    trackImageView.image = placeholder
                }

                activityIndicator.startAnimating()
                apiService.getTrackInfo(byTrackName: track.name, byArtistName: track.artistName) { data, error in

                    if let err = error {
                        NSLog("Error: \(err)")

                    } else if let info = data?.info, info != "" {
                        self.trackInfo.text = info.removeStartingNewlineIfExists().removeHTMLTags()
                    }
                    self.activityIndicator.stopAnimating()
                }
            }

        }
    }

}
