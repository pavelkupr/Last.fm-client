//
//  CustomBar.swift
//  Last.fm client
//
//  Created by student on 4/23/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

@IBDesignable class CustomBar: UIStackView {
    
    @IBInspectable var buttonColor: UIColor = UIColor.clear {
        didSet {
            for btn in buttons {
                btn.backgroundColor = buttonColor
            }
        }
    }
    var itemsCount: Int {
        get {
            return buttons.count
        }
    }
    var delegate: CustomBarDelegate?
    private var buttons = [UIButton]()
    private var border: CALayer?
    private var selected: Int? {
        didSet {
            paintBorder()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setButtons(withItems items: [UIButton]) {
        for button in buttons {
            button.removeFromSuperview()
        }
        if border != nil {
            border?.removeFromSuperlayer()
        }
        
        buttons = items
        for item in items {
            setButtonStyle(item)
            
            item.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            addArrangedSubview(item)
        }
        border = layer.addBorder(edge: .bottom, color: tintColor, thickness: 2,
                                 start: 0, length: 0)
        
        selected = 0
        buttons[0].isSelected = true
        
    }
    
    override func layoutSubviews() {
        paintBorder()
    }
    
    func getSelected() -> UIButton? {
        return buttons.first{$0.isSelected}
    }
    
    @objc private func ratingButtonTapped(button: UIButton) {
        selected = buttons.firstIndex(of: button)
        
        for btn in buttons {
            if btn == button {
                btn.isSelected = true
            } else {
                btn.isSelected = false
            }
        }
        delegate?.customBarSelectedDidChange(button: button)
    }
    
    private func setButtonStyle(_ button: UIButton) {
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.setTitleColor(tintColor, for: .selected)
        button.setTitleShadowColor(tintColor, for: .selected)
        button.backgroundColor = buttonColor
    }
    
    private func paintBorder() {
        if let selected = selected {
            let width = bounds.width / CGFloat(buttons.count)
            border?.setFrame(edge: .bottom, color: tintColor, thickness: 2,
                             start: CGFloat(selected) * width, length: width)
        }
    }
}

protocol CustomBarDelegate {
    func customBarSelectedDidChange(button: UIButton)
}
