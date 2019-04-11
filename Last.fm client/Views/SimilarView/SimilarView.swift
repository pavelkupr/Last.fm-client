//
//  SimilarView.swift
//  Last.fm client
//
//  Created by student on 4/11/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class SimilarView: UIView {
    
    // MARK: Properties
    
    @IBOutlet var contentView: UIStackView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        Bundle.main.loadNibNamed("SimilarView", owner: self, options: nil)
        addSubview(contentView)
        addFitConstraints(view: contentView)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "CustomCell")
        headerView.moreButton.isHidden = true
        headerView.label.text = "Similar"
    }

}
