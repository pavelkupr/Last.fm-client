//
//  ArtistInfoViewController.swift
//  Last.fm client
//
//  Created by student on 3/26/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,
RatingControlDelegate {

    // MARK: Properties
    
    @IBOutlet weak var infoView: InfoView!
    @IBOutlet weak var favoriteButton: FavoriteButton!
    
    private let apiService = APIService()
    private var data: Storable?
    private var similar = [Storable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.similarView.collectionView.delegate = self
        infoView.similarView.collectionView.dataSource = self
        infoView.ratingControl.delegate = self
        favoriteButton.button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
        
        if let value = data {
            loadAdditionalInfo(value)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let value = data {
            infoView.updateMainInfoSection(withStorableData: value)
            
            if let isFavorite = value.isFavorite {
                favoriteButton.isHidden = false
                favoriteButton.button.isSelected = isFavorite
            } else {
                favoriteButton.isHidden = true
            }
        }
    }
    
    static func getInstanceFromStoryboard() -> InfoViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "InfoViewController")
            as? InfoViewController else {
                fatalError("Can't cast controller")
        }
        return controller
    }
    
    func setStoreableData(_ data: Storable) {
        self.data = data
    }
    
    // MARK: RatingControlDelegate
    
    func ratingDidChange(newRating: Int16) {
        data?.rating = newRating
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
        guard let index = collectionView.indexPath(for: cell) else {
            fatalError("Unreacheble index")
        }

        cell.imageView.highlightBorder(withColour: cell.tintColor)
        pushSameController(withStoreableData: similar[index.row])
    }

    // MARK: Private Methods

    private func loadAdditionalInfo(_ value: Storable) {
        infoView.activityIndicator.startAnimating()
        value.getAddidtionalInfo { info in
            if let about = info.aboutInfo {
                self.infoView.updateAboutSection(withInfo:
                    about.removeStartingNewlineIfExists().repalceHTMLTags(with: "\n"))
            }
            if let similar = info.similar {
                self.similar = similar
                self.infoView.updateSimilarSection()
            }
            if let parent = info.parent {
                self.infoView.updateAlbumSection(withAlbum: parent)
            }
            self.infoView.activityIndicator.stopAnimating()
        }
        
    }
    
    @objc private func buttonTapped(button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            data?.addToFavorite()
        } else {
            data?.removeFromFavorite()
        }
    }
    
    private func pushSameController(withStoreableData value: Storable) {
        let viewController = InfoViewController.getInstanceFromStoryboard()
        viewController.setStoreableData(value)
        navigationController?.pushViewController(viewController, animated: true)
    }

}
