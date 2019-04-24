//
//  FavoriteButton.swift
//  Last.fm client
//
//  Created by student on 4/23/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

@IBDesignable class FavoriteButton: UIView {
    
    var button: UIButton!
    private var heightConstraint: NSLayoutConstraint!
    private var widthConstraint: NSLayoutConstraint!
    
    @IBInspectable var buttonColor: UIColor = UIColor.black {
        didSet {
            button.tintColor = buttonColor
        }
    }
    
    @IBInspectable var btnSize: CGFloat = 35 {
        didSet {
            heightConstraint.constant = btnSize
            widthConstraint.constant = btnSize
            setButton()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        setButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setConstraints()
        setButton()
    }
    
    // MARK: Private methods
    
    private func setButton() {
        button?.removeFromSuperview()
        button = UIButton()
        let bundle = Bundle(for: type(of: self))
        let filledHeart = UIImage(named: "filledHeart", in: bundle, compatibleWith: self.traitCollection)
        let emptyHeart = UIImage(named:"emptyHeart", in: bundle, compatibleWith: self.traitCollection)
        
        button.tintColor = buttonColor
        button.setImage(emptyHeart, for: .normal)
        button.setImage(filledHeart, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: btnSize).isActive = true
        button.widthAnchor.constraint(equalToConstant: btnSize).isActive = true
        addSubview(button)
    }
    
    private func setConstraints() {
        heightConstraint = heightAnchor.constraint(equalToConstant: btnSize)
        widthConstraint = widthAnchor.constraint(equalToConstant: btnSize)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
    }
}
