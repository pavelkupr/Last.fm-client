//
//  CircleImageView.swift
//  Last.fm client
//
//  Created by Pavel on 3/25/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircle()
    }

    func highlightBorder(withColour colour: UIColor) {
        animateBorderColor(toColor: colour, duration: 0.4)
        animateBorderColor(toColor: .gray, duration: 0.4)
    }

    // MARK: Private methods

    private func createCircle() {

        layer.cornerRadius = 20
        clipsToBounds = true
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.gray.cgColor
    }
}
