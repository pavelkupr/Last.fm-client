//
//  UIViewControllerExtension.swift
//  Last.fm client
//
//  Created by student on 5/2/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

extension UIViewController {

    func showToast(message: String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100,
                                               y: self.view.frame.size.height/2 - 15, width: 200, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.5, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(_) in
            toastLabel.removeFromSuperview()
        })
    }

}
