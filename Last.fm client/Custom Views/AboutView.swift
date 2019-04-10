//
//  AboutView.swift
//  Last.fm client
//
//  Created by student on 4/10/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class AboutView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet var summaryConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    func setAboutInfo(withInfo info: String) {
        isHidden = false
        infoTextView.text = info
        layoutIfNeeded()

        if infoTextView.contentSize.height <= summaryConstraint.constant {
            headerView.moreButton.isHidden = true
        } else {
            summaryConstraint.isActive = true
        }
    }

    // MARK: Private methods

    private func initView() {
        Bundle.main.loadNibNamed("AboutView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        headerView.label.text = "About"
        summaryConstraint.isActive = false
        headerView.moreButton.addTarget(self, action:
            #selector(self.changeInfoMode(_:)), for: .touchUpInside)
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
