//
//  UIViewExtension.swift
//  Last.fm client
//
//  Created by student on 4/10/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

extension UIView {
    func animateBorderColor(toColor: UIColor, duration: Double) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = layer.borderColor
        animation.toValue = toColor.cgColor
        animation.duration = duration
        layer.add(animation, forKey: "borderColor")
        layer.borderColor = toColor.cgColor
    }
    
    func addFitConstraints(view : UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let bottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal,
                                        toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal,
                                     toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal,
                                         toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal,
                                          toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        
        addConstraints([bottom, top, leading, trailing])
    }
}
