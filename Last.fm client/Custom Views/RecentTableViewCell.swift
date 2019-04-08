//
//  RecentTableViewCell.swift
//  Last.fm client
//
//  Created by student on 3/28/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class RecentTableViewCell: UITableViewCell {

    @IBOutlet weak var infoView: CustomCellView!

    func fillCell(withSearch search: String) {
        infoView.setRecentMode()
        infoView.mainInfoLabel.text = search
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
