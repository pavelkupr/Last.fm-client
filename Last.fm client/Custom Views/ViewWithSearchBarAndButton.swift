//
//  ViewWithSearchBarAndButton.swift
//  Last.fm client
//
//  Created by Pavel on 4/1/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit


class ViewWithSearchBarAndButton: UIView {

    let buttonWidth: CGFloat = 100
    var isFullSearchBar = true {
        didSet{
            changeMode()
        }
    }
    var searchBar: UISearchBar!
    var cancelButton: UIButton!
    
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
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        searchBar.barTintColor = UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        cancelButton = UIButton(frame: CGRect(x: bounds.width, y: 0, width: bounds.width, height: bounds.height))
        cancelButton.backgroundColor = UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.blue, for: .normal)
        addSubview(searchBar)
        addSubview(cancelButton)
        layer.addBorder(edge: .bottom, color: UIColor.gray, thickness: 1)
        layer.addBorder(edge: .top, color: UIColor.gray, thickness: 1)
    }
    
    private func changeMode() {
        UIView.transition(with: self,
                          duration: 0.4,
                          options: [],
                          animations: {
                            let rect = self.bounds
                            if self.isFullSearchBar {
                                self.searchBar.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
                                self.cancelButton.frame = CGRect(x: rect.width, y: 0, width: rect.width, height: rect.height)
                            }
                            else {
                                self.searchBar.frame = CGRect(x: 0, y: 0, width: rect.width-self.buttonWidth, height: rect.height)
                                self.cancelButton.frame = CGRect(x: rect.width-self.buttonWidth, y: 0, width: rect.width, height: rect.height)
                            }
                            
        }
        )
    }
}
