//
//  ArtistInfoViewController.swift
//  Last.fm client
//
//  Created by student on 3/26/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import SDWebImage

class InfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: Properties

    private let apiService = APIService()
    private var isArtistMode = true
    private var artist: Artist?
    private var track: Track?
    private var placeholder: UIImage?
    private var similar = [Artist]()

    @IBOutlet weak var infoView: InfoView!

    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.collectionView.delegate = self
        infoView.collectionView.dataSource = self

        if let placeholder = UIImage(named: "Placeholder") {
            self.placeholder = placeholder
        } else {
            NSLog("Can't find placeholder")
        }

        if isArtistMode {
            loadArtistInfo()
        } else {
            loadTrackInfo()
        }
    }

    func setArtist(_ artist: Artist) {
        isArtistMode = true
        self.artist = artist
    }

    func setTrack(_ track: Track) {
        isArtistMode = false
        self.track = track
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similar.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell",
                                                            for: indexPath) as? CustomCollectionViewCell else {
            fatalError("Unexpected type")
        }
        
        cell.fillCell(withArtist: similar[indexPath.row])
        return cell
    }

    // MARK: Private Methods

    private func loadArtistInfo() {

        if let artistVal = artist {
            infoView.bottomLabel.isHidden = true
            infoView.mainLabel.text = artistVal.name

            if let largeImg = artistVal.photoUrls[.extralarge], let url = URL(string: largeImg) {
                infoView.imageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: nil)

            } else {
                infoView.imageView.image = placeholder
            }

            infoView.activityIndicator.startAnimating()
            apiService.getArtistInfo(byName: artistVal.name) { data, error in

                if let err = error {
                    NSLog("Error: \(err)")

                } else if let data = data {
                    if let info = data.info, info != "" {
                        self.infoView.setAboutInfo(withInfo:
                            info.removeStartingNewlineIfExists().removeHTMLTags(with: "\n"))
                    }
                    self.similar = data.similar
                    self.infoView.showSimilar()
                }
                self.infoView.activityIndicator.stopAnimating()
            }
        }

    }

    private func loadTrackInfo() {

        if let trackVal = track {
            infoView.bottomLabel.isHidden = false
            infoView.mainLabel.text = trackVal.name
            infoView.bottomLabel.text = "by "+trackVal.artistName

            if let largeImg = trackVal.photoUrls[.extralarge], let url = URL(string: largeImg) {
                infoView.imageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: nil)

            } else {
                infoView.imageView.image = placeholder
            }

            infoView.activityIndicator.startAnimating()
            apiService.getArtistInfo(byName: trackVal.name) { data, error in

                if let err = error {
                    NSLog("Error: \(err)")

                } else if let data = data {
                    if let info = data.info, info != "" {
                        self.infoView.setAboutInfo(withInfo:
                            info.removeStartingNewlineIfExists().removeHTMLTags(with: "\n"))
                    }
                }
                self.infoView.activityIndicator.stopAnimating()
            }
        }
    }
}
