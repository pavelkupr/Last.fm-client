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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var aboutHeader: HeaderView!
    @IBOutlet var summaryConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        aboutHeader.label.text = "About"
        if let placeholder = UIImage(named: "Placeholder") {
            self.placeholder = placeholder
        } else {
            NSLog("Can't find placeholder")
        }

        loadInfo()
    }

    // MARK: Private Methods

    private func loadInfo() {

        if let artistVal = artist {

            if artistVal.info == nil {
                artistName.text = artistVal.name

                if let largeImg = artistVal.photoUrls[.extralarge], let url = URL(string: largeImg) {
                    artistImageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: nil)

                } else {
                    artistImageView.image = placeholder
                }

                activityIndicator.startAnimating()
                apiService.getArtistInfo(byName: artistVal.name) { data, error in

                    if let err = error {
                        NSLog("Error: \(err)")

                    } else if let data = data {
                        if let info = data.info, info != "" {
                            self.artistInfo.text = info.removeStartingNewlineIfExists().removeHTMLTags(with: "\n")
                            self.aboutHeader.moreButton.addTarget(self, action: #selector(self.changeInfoMode(_:)),
                                                                  for: .touchUpInside)
                            self.aboutHeader.isHidden = false
                        }
                    }
                    self.activityIndicator.stopAnimating()
                }
            }

        }
    }

    @objc private func changeInfoMode(_ sender: UIButton) {

        if self.summaryConstraint.isActive {
            self.summaryConstraint.isActive = false
            sender.setTitle("Less", for: .normal)
        } else {
            self.summaryConstraint.isActive = true
            sender.setTitle("More...", for: .normal)
        }

        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
}
