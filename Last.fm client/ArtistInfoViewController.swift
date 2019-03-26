//
//  ArtistInfoViewController.swift
//  Last.fm client
//
//  Created by student on 3/26/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import SDWebImage

class ArtistInfoViewController: UIViewController {

    // MARK: Properties
    var artist: Artist? {
        didSet {
            loadInfo()
        }
    }
    private var placeholder: UIImage?
    
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistInfo: UILabel!
    
    @IBOutlet weak var artistInfoView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let placeholder = UIImage(named: "Placeholder") {
            self.placeholder = placeholder
        } else {
            NSLog("Can't find placeholder")
        }
        
        loadInfo()
        // Do any additional setup after loading the view.
    }
    
    // MARK: Private Methods
    
    private func loadInfo() {
        
        if let artist = artist {
            artistName.text = artist.name
            artistInfoView.text = artist.info ?? ""
            
            if let largeImg = artist.photoUrls["extralarge"], let url = URL(string: largeImg) {
                
                artistImageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: nil)
                
            } else {
                
                artistImageView.image = placeholder
            }
        }
    }
}
