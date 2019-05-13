//
//  InfoView.swift
//  Last.fm client
//
//  Created by student on 4/8/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class InfoView: UIView {

    // MARK: Properties

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: RoundedImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!

    @IBOutlet weak var aboutView: AboutView!
    @IBOutlet weak var similarView: SimilarView!
    @IBOutlet weak var albumView: AlbumView!
    @IBOutlet var summaryConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private let imageLoader = ImageLoader()
    private let imageSize = ImageSize.extralarge
    private lazy var placeholder: UIImage? = {
        if let placeholder = UIImage(named: "Placeholder") {
            return placeholder

        } else {
            NSLog("Can't find placeholder")
            return nil
        }
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    func updateMainInfoSection(withStorableData data: Storable) {

        mainLabel.text = data.mainInfo

        if let bottom = data.bottomInfo {
            bottomLabel.isHidden = false
            bottomLabel.text = "by " + bottom
        }

        if let imgs = data.imageURLs, let img = imgs[imageSize], let url = URL(string: img) {
            imageLoader.downloadImage(from: url, to: imageView, placeholder: placeholder)
        } else {
            imageView.image = placeholder
        }

        if let rating = data.rating {
            ratingControl.isHidden = false
            ratingControl.rating = rating
        }

    }

    func updateAboutSection(withInfo info: String) {
        aboutView.infoTextView.text = info

        if aboutView.getContentHeight() <= summaryConstraint.constant {
            aboutView.headerView.moreButton.isHidden = true
            summaryConstraint.isActive = false
        }
        aboutView.isHidden = false
    }

    func updateAlbumSection(withAlbum album: Storable) {
        albumView.setAlbum(album)
        albumView.isHidden = false
    }

    func updateSimilarSection() {
        similarView.collectionView.reloadData()
        similarView.isHidden = false
    }

    // MARK: Private methods

    private func initView() {
        Bundle.main.loadNibNamed("InfoView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        aboutView.headerView.moreButton.addTarget(self, action:
            #selector(self.changeInfoMode(_:)), for: .touchUpInside)

        bottomLabel.isHidden = true
    }

    @objc private func changeInfoMode(_ sender: UIButton) {

        if summaryConstraint.isActive {
            summaryConstraint.isActive = false
            sender.setTitle("Less", for: .normal)
        } else {
            summaryConstraint.isActive = true
            sender.setTitle("More", for: .normal)
        }

        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
}
