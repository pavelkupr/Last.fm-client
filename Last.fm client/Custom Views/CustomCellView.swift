//
//  CustomCellView.swift
//  Last.fm client
//
//  Created by Pavel on 4/8/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class CustomCellView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: RoundedImageView!
    @IBOutlet weak var mainInfoLabel: UILabel!
    @IBOutlet weak var bottomInfoLabel: UILabel!
    @IBOutlet weak var headInfoLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    func setArtistMode(withTop top: Bool) {
        stackView.alignment = .top
        bottomInfoLabel.isHidden = true
        imageView.isHidden = false
        mainInfoLabel.isHidden = false
        headInfoLabel.isHidden = !top
    }

    func setTrackMode(withTop top: Bool) {
        stackView.alignment = .top
        bottomInfoLabel.isHidden = false
        imageView.isHidden = false
        mainInfoLabel.isHidden = false
        headInfoLabel.isHidden = !top
    }

    func setRecentMode() {
        stackView.alignment = .center
        bottomInfoLabel.isHidden = true
        imageView.isHidden = true
        mainInfoLabel.isHidden = false
        headInfoLabel.isHidden = true
    }

    // MARK: Private methods

    private func initView() {
        Bundle.main.loadNibNamed("CustomCellView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
