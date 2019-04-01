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
    var isSearchMode = true {
        didSet {
            animateModeChange()
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
        if isSearchMode {
            searchBar = UISearchBar(frame: CGRect(x: 0, y: 0,
                                                  width: bounds.width, height: bounds.height))
            cancelButton = UIButton(frame: CGRect(x: bounds.width, y: 0,
                                                  width: 0, height: bounds.height))
            cancelButton.titleLabel?.alpha = 0
        } else {
            searchBar = UISearchBar(frame: CGRect(x: 0, y: 0,
                                                  width: bounds.width-buttonWidth, height: bounds.height))
            cancelButton = UIButton(frame: CGRect(x: bounds.width-buttonWidth, y: 0,
                                                  width: buttonWidth, height: bounds.height))
        }
        addSubview(searchBar)
        addSubview(cancelButton)

        searchBar.barTintColor = UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        cancelButton.backgroundColor = UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)

        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(tintColor, for: .normal)
        cancelButton.setTitleColor(UIColor.lightGray, for: .highlighted)

        layer.addBorder(edge: .bottom, color: UIColor.lightGray, thickness: 1)
        layer.addBorder(edge: .top, color: UIColor.lightGray, thickness: 1)
    }

    private func animateModeChange() {
        if !isSearchMode {
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.unsetSearchMode()
                            self.layoutIfNeeded()
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.2) {
                                self.cancelButton.titleLabel?.alpha = 1
                                self.layoutIfNeeded()
                            }
            })
        } else {
            UIView.animate(withDuration: 0.2,
                           animations: {
                            self.cancelButton.titleLabel?.alpha = 0
                            self.layoutIfNeeded()
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.setSearchMode()
                                self.layoutIfNeeded()
                            }
            })
        }
    }

    private func setSearchMode() {
        searchBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        cancelButton.frame = CGRect(x: bounds.width, y: 0, width: 0, height: bounds.height)
    }

    private func unsetSearchMode() {
        searchBar.frame = CGRect(x: 0, y: 0, width: bounds.width-buttonWidth, height: bounds.height)
        cancelButton.frame = CGRect(x: bounds.width-buttonWidth, y: 0, width: buttonWidth, height: bounds.height)
    }
}

extension CALayer {

    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {

        let border = CALayer()

        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }

        border.backgroundColor = color.cgColor

        addSublayer(border)
    }
}
