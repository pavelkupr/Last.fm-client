//
//  InfoView.swift
//  Last.fm client
//
//  Created by student on 4/8/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class InfoView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: RoundedImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var headerAboutView: HeaderView!
    @IBOutlet weak var aboutView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var summaryConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerSimilarView: HeaderView!

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

    func setAboutInfo(withInfo info: String) {
        aboutView.text = info
        headerAboutView.label.text = "About"
        headerAboutView.isHidden = false
        aboutView.isHidden = false
        layoutIfNeeded()

        if aboutView.contentSize.height <= summaryConstraint.constant {
            headerAboutView.moreButton.isHidden = true
        } else {
            summaryConstraint.isActive = true
            headerAboutView.moreButton.isHidden = false
            headerAboutView.moreButton.addTarget(self, action: #selector(self.changeInfoMode(_:)),
                                                 for: .touchUpInside)
        }
    }

    func fillView(withStorableData data: Storable) {

        mainLabel.text = data.mainInfo

        if let bottom = data.bottomInfo {
            bottomLabel.isHidden = false
            bottomLabel.text = "by "+bottom
        }

        imageView.isHidden = false
        if let imgs = data.imageURLs, let img = imgs[imageSize], let url = URL(string: img) {
            imageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: nil)
        } else {
            imageView.image = placeholder
        }

    }

    func showSimilar() {
        collectionView.reloadData()
        headerSimilarView.label.text = "Similar"
        headerSimilarView.moreButton.isHidden = true
        collectionView.isHidden = false
        headerSimilarView.isHidden = false
    }

    // MARK: Private methods

    private func initView() {
        Bundle.main.loadNibNamed("InfoView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "CustomCell")
        headerAboutView.isHidden = true
        aboutView.isHidden = true
        collectionView.isHidden = true
        headerSimilarView.isHidden = true
        imageView.isHidden = true
        bottomLabel.isHidden = true
        summaryConstraint.isActive = false
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
