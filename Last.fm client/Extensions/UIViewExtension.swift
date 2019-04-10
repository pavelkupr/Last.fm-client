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
}
