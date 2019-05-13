//
//  AboutView.swift
//  Last.fm client
//
//  Created by student on 4/10/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class AboutView: UIView {

    // MARK: Properties

    @IBOutlet var contentView: UIStackView!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var headerView: HeaderView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    func getContentHeight() -> CGFloat {
        return contentView.spacing + infoTextView.text.height(withConstrainedWidth:
            infoTextView.bounds.width, font: infoTextView.font!) + headerView.bounds.height
    }

    // MARK: Private methods

    private func initView() {
        Bundle.main.loadNibNamed("AboutView", owner: self, options: nil)
        addSubview(contentView)
        addFitConstraints(view: contentView)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        headerView.headerName.text = "About"
    }

}
