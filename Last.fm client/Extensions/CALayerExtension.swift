//
//  CALayerExtension.swift
//  Last.fm client
//
//  Created by student on 4/3/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

extension CALayer {

    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat, start: CGFloat, length: CGFloat) -> CALayer {

        let border = CALayer()

        switch edge {
        case .top:
            border.frame = CGRect(x: start, y: 0, width: start + length, height: thickness)
        case .bottom:
            border.frame = CGRect(x: start, y: frame.height - thickness, width: start + length, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: start, width: thickness, height: start + length)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: start, width: thickness, height: start + length)
        default:
            break
        }

        border.backgroundColor = color.cgColor

        addSublayer(border)
        return border
    }

    func setFrame(edge: UIRectEdge, color: UIColor, thickness: CGFloat, start: CGFloat, length: CGFloat) {
        guard let rect = superlayer?.frame else {
            return
        }

        switch edge {
        case .top:
            frame = CGRect(x: start, y: 0, width: start + length, height: thickness)
        case .bottom:
            frame = CGRect(x: start, y: rect.height - thickness, width: start + length, height: thickness)
        case .left:
            frame = CGRect(x: 0, y: start, width: thickness, height: start + length)
        case .right:
            frame = CGRect(x: rect.width - thickness, y: start, width: thickness, height: start + length)
        default:
            break
        }

        backgroundColor = color.cgColor
    }
}
