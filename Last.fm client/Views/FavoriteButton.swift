//
//  FavoriteButton.swift
//  Last.fm client
//
//  Created by student on 4/23/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class FavoriteButton: UIView {
    
    var button: UIButton!
    
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
        button = UIButton()
        let bundle = Bundle(for: type(of: self))
        let filledHeart = UIImage(named: "filledHeart", in: bundle, compatibleWith: self.traitCollection)
        let emptyHeart = UIImage(named:"emptyHeart", in: bundle, compatibleWith: self.traitCollection)
        
        button.setImage(emptyHeart, for: .normal)
        button.setImage(filledHeart, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.widthAnchor.constraint(equalToConstant: 35).isActive = true
        addSubview(button)
    }
}
