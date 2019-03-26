//
//  TrackTableViewCell.swift
//  Last.fm client
//
//  Created by student on 3/26/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class TrackTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var trackImageView: CircleImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
