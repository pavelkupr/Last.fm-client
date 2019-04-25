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
    @IBOutlet weak var headerName: UILabel!
    @IBOutlet weak var leadingShift: NSLayoutConstraint!
    private var bottomBorder: CALayer?

    var isWithBorder = false
    var shift: CGFloat = 0 {
        didSet {
            leadingShift.constant = shift
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    // MARK: Private methods

    private func initView() {
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        addSubview(contentView)
        addFitConstraints(view: contentView)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    override func layoutSubviews() {
        if isWithBorder {
            if bottomBorder == nil {
                bottomBorder = layer.addBorder(edge: .bottom, color: .lightGray,
                                               thickness: 1, start: 0, length: bounds.width)
            } else {
                bottomBorder?.setFrame(edge: .bottom, color: .lightGray,
                                       thickness: 1, start: 0, length: bounds.width)
            }
        }
    }
}
