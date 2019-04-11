//
//  SectionHeaderView.swift
//  Last.fm client
//
//  Created by Pavel on 3/31/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    // MARK: Properties
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var leadingShift: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    init(labelShift shift: CGFloat, nameOfHeader: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        initView()
        leadingShift.constant = shift
        label?.text = nameOfHeader

    }

    // MARK: Private methods

    private func initView() {
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        addSubview(contentView)
        addFitConstraints(view: contentView)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
