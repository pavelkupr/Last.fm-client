//
//  FavoriteButton.swift
//  Last.fm client
//
//  Created by student on 4/23/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

@objc enum BtnType: Int {
    case Fav, Geo
}

@IBDesignable class CustomButton: UIView {
    
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
    
    @IBInspectable var buttonType: BtnType = .Fav {
        didSet {
            setImg()
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
        setImg()
        button.tintColor = buttonColor
        
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
    
    private func setImg() {
        let bundle = Bundle(for: type(of: self))
        switch buttonType {
        case .Fav:
            let filledHeart = UIImage(named: "filledHeart", in: bundle, compatibleWith: self.traitCollection)
            let emptyHeart = UIImage(named:"emptyHeart", in: bundle, compatibleWith: self.traitCollection)
            
            button.setImage(emptyHeart, for: .normal)
            button.setImage(filledHeart, for: .selected)
        case .Geo:
            let globe = UIImage(named: "globe", in: bundle, compatibleWith: self.traitCollection)?.withRenderingMode(.alwaysTemplate)
            let filledGlobe = UIImage(named:"filledGlobe", in: bundle, compatibleWith: self.traitCollection)?.withRenderingMode(.alwaysTemplate)
            button.setImage(globe, for: .normal)
            button.setImage(filledGlobe, for: .highlighted)
        }
    }
}
