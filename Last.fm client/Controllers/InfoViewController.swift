//
//  ArtistInfoViewController.swift
//  Last.fm client
//
//  Created by student on 3/26/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

enum DataRepresentationMode {
    case artist, track, none
}

class InfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: Properties

    private let apiService = APIService()
    private var mode = DataRepresentationMode.none
    private var data: Storable?
    private var similar = [Storable]()

    @IBOutlet weak var infoView: InfoView!

    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.collectionView.delegate = self
        infoView.collectionView.dataSource = self

        if let value = data {
            infoView.fillView(withStorableData: value)

            switch mode {
            case .artist:
                loadArtistInfo(value)
            case .track:
                loadTrackInfo(value)
            default:
                break
            }
        }
    }

    func setStoreableData(_ data: Storable, mode: DataRepresentationMode) {
        self.mode = mode
        self.data = data
    }

    // MARK: CollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similar.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell",
                                                            for: indexPath) as? CustomCollectionViewCell else {
            fatalError("Unexpected type")
        }

        cell.fillCell(withStorableData: similar[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell else {
            fatalError("Select unselectable cell")
        }
        guard let index = infoView.collectionView.indexPath(for: cell) else {
            fatalError("Unreacheble index")
        }

        cell.imageView.highlightBorder(withColour: cell.tintColor)
        pushSameController(withStoreableData: similar[index.row])
    }

    // MARK: Private Methods

    private func loadArtistInfo(_ value: Storable) {
        infoView.activityIndicator.startAnimating()
        apiService.getArtistInfo(byName: value.mainInfo) { data, error in

            if let err = error {
                NSLog("Error: \(err)")

            } else if let data = data {
                if let info = data.info, info != "" {
                    self.infoView.setAboutInfo(withInfo:
                        info.removeStartingNewlineIfExists().repalceHTMLTags(with: "\n"))
                }
                if !data.similar.isEmpty {
                    self.similar = data.similar
                    self.infoView.showSimilar()
                }
            }
            self.infoView.activityIndicator.stopAnimating()
        }
    }

    private func loadTrackInfo(_ value: Storable) {
        if let bottomData = value.bottomInfo {
            infoView.activityIndicator.startAnimating()
            apiService.getTrackInfo(byTrackName: value.mainInfo, byArtistName:
            bottomData) { data, error in

                if let err = error {
                    NSLog("Error: \(err)")

                } else if let data = data {
                    if let info = data.info, info != "" {
                        self.infoView.setAboutInfo(withInfo:
                            info.removeStartingNewlineIfExists().repalceHTMLTags(with: "\n"))
                    }
                    if let album = data.album {
                        self.infoView.setAlbum(withAlbum: album)
                    }
                }
                self.infoView.activityIndicator.stopAnimating()
            }
        }
    }

    private func pushSameController(withStoreableData value: Storable) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "InfoViewController")
            as? InfoViewController else {
                fatalError("Can't cast controller")
        }
        viewController.setStoreableData(value, mode: mode)
        navigationController?.pushViewController(viewController, animated: true)
    }

}
