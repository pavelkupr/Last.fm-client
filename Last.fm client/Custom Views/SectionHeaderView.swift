//
//  SectionHeaderView.swift
//  Last.fm client
//
//  Created by Pavel on 3/31/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class SectionHeaderView: UIView {

    // MARK: Properties

    private let labelShift: CGFloat = 30
    private let moreButtonWidth: CGFloat = 100
    private let labelWidth: CGFloat = 200
    private let backColor = UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    
    override var frame: CGRect {
        didSet {
            updateView()
        }
    }
    override var bounds: CGRect {
        didSet {
            updateView()
        }
    }
    var moreButton: UIButton?
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    init(frame: CGRect, nameOfHeader: String) {
        super.init(frame: frame)
        initView()
        label?.text = nameOfHeader

    }

    func addMoreButton() {
        if moreButton == nil {
            moreButton = UIButton(frame: CGRect(x: bounds.width-moreButtonWidth, y: 0,
                                                width: moreButtonWidth, height: bounds.height))
            moreButton?.setTitle("More...", for: .normal)

            moreButton?.titleLabel?.font = UIFont(name: "System", size: 14)
            moreButton?.setTitleColor(tintColor, for: .normal)
            moreButton?.setTitleColor(UIColor.lightGray, for: .highlighted)
            addSubview(moreButton!)
        }
    }

    // MARK: Private methods

    private func updateView() {
        if let button = moreButton {
            button.frame = CGRect(x: bounds.width-moreButtonWidth, y: 0,
                                  width: moreButtonWidth, height: bounds.height)
        }
        if label != nil {
            label.frame = CGRect(x: labelShift, y: 0, width: labelWidth, height: bounds.height)
        }
    }
    
    private func initView() {
        backgroundColor = backColor
        label = UILabel(frame: CGRect(x: labelShift, y: 0, width: labelWidth, height: bounds.height))
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = UIColor.black

        addSubview(label)
    }

}
