//
//  SectionHeaderView.swift
//  Last.fm client
//
//  Created by Pavel on 3/31/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class SectionHeaderView: UIView {

    // MARK: Properties
    
    var label: UILabel?
    
    private let labelShift: CGFloat = 30
    private let backColor = UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    init(frame: CGRect, nameOfHeader: String) {
        super.init(frame: frame)
        initView()
        label?.text = nameOfHeader
    }
    
    // MARK: Private methods
    
    private func initView() {
        
        backgroundColor = backColor
        label = UILabel(frame: CGRect(x: labelShift, y: 0, width: bounds.width - labelShift, height: bounds.height))
        label?.font = UIFont.boldSystemFont(ofSize: 15)
        label?.textColor = UIColor.black
        
        addSubview(label!)
        
    }

}
