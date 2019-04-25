//
//  CustomSearchBar.swift
//  Last.fm client
//
//  Created by student on 4/8/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {
    
    override func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) {
        super.setShowsCancelButton(showsCancelButton, animated: animated)

        showCancelButton()
    }
    
    func resignFirstResponderAndShowCancelButton() {
        super.resignFirstResponder()
        showCancelButton()
    }
    
    private func showCancelButton() {
        if let cancelButton = self.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
    }
}
