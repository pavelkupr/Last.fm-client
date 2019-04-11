//
//  TableViewActivityIndicator.swift
//  Last.fm client
//
//  Created by student on 4/4/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class TableViewActivityIndicator: UIView {
    
    // MARK: Properties
    
    private var activityIndicator: UIActivityIndicatorView?
    var isLoading = false
    override var frame: CGRect {
        didSet {
             activityIndicator?.center = CGPoint(x: bounds.width/2, y: bounds.height/2)

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

    func showAndAnimate() {
        isLoading = true
        activityIndicator?.isHidden = false
        activityIndicator?.startAnimating()
    }

    func hideAndStop() {
        isLoading = false
        activityIndicator?.stopAnimating()
        activityIndicator?.isHidden = true
    }

    // MARK: Private methods

    private func initView() {
        bounds.size.height = 100
        activityIndicator = UIActivityIndicatorView(style: .gray)
        addSubview(activityIndicator!)
    }

}
