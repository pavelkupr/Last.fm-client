//
//  AlbumView.swift
//  Last.fm client
//
//  Created by student on 4/11/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class AlbumView: UIView {

    // MARK: Properties

    @IBOutlet var contentView: UIStackView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var imageView: RoundedImageView!
    @IBOutlet weak var nameLabel: UILabel!

    private let imageLoader = ImageLoader()
    private let imageSize = ImageSize.large
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

    func setAlbum(_ album: Storable) {
        headerView.headerName.text = "Album"
        nameLabel.text = album.mainInfo
        if let imgs = album.imageURLs, let img = imgs[imageSize], let url = URL(string: img) {
            imageLoader.downloadImage(from: url, to: imageView, placeholder: placeholder)
        } else {
            imageView.image = placeholder
        }
    }

    // MARK: Private methods

    private func initView() {
        Bundle.main.loadNibNamed("AlbumView", owner: self, options: nil)
        addSubview(contentView)
        addFitConstraints(view: contentView)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        headerView.moreButton.isHidden = true
        headerView.headerName.text = "Album"
    }
}
