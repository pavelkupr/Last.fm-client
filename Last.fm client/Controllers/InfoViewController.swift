//
//  ArtistInfoViewController.swift
//  Last.fm client
//
//  Created by student on 3/26/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import SDWebImage

enum DataRepresentationMode {
    case artist, track
}

class InfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: Properties

    private let apiService = APIService()
    private var mode = DataRepresentationMode.artist
    private var data: Storable?
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
        switch mode {
        case .artist:
            loadArtistInfo()
        case .track:
            loadTrackInfo()

        }
    }

    func setStoreableData(_ data: Storable, mode: DataRepresentationMode) {
        self.mode = mode
        self.data = data
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

        if let dataVal = data {
            infoView.bottomLabel.isHidden = true
            infoView.mainLabel.text = dataVal.mainInfo

            if let imgs = dataVal.imageURLs, let img = imgs[.extralarge], let url = URL(string: img) {
                infoView.imageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: nil)

            } else {
                infoView.imageView.image = placeholder
            }

            infoView.activityIndicator.startAnimating()
            apiService.getArtistInfo(byName: dataVal.mainInfo) { data, error in

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

        if let dataVal = data {
            infoView.bottomLabel.isHidden = false
            infoView.mainLabel.text = dataVal.mainInfo

            if let imgs = dataVal.imageURLs, let img = imgs[.extralarge], let url = URL(string: img) {
                infoView.imageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: nil)

            } else {
                infoView.imageView.image = placeholder
            }

            if let bottomData = dataVal.bottomInfo {
                infoView.bottomLabel.text = "by " + bottomData
                infoView.activityIndicator.startAnimating()
                apiService.getTrackInfo(byTrackName: dataVal.mainInfo, byArtistName:
                bottomData) { data, error in

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
}
