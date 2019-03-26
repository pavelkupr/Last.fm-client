//
//  ArtistsTableViewController.swift
//  Last.fm client
//
//  Created by student on 3/25/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import SDWebImage

class ArtistsTableViewController: UITableViewController {
    
    // MARK: Properties
    
    private var placeholder: UIImage?
    private let serviceModel = ServiceModel()
    private var artists = [Artist]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let placeholder = UIImage(named: "Placeholder") {
            self.placeholder = placeholder
        } else {
            NSLog("Can't find placeholder")
        }
        
        loadArtists()
    }
    
    // MARK: Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return artists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath) as? ArtistTableViewCell else {
            
            fatalError("Unexpected type of cell")
        }
        
        let artist = artists[indexPath.row]
        
        cell.artistName.text = artist.name
        
        if let largeImg = artist.photoUrls["large"], let url = URL(string: largeImg) {
            
            cell.artistImageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: nil)
            /*{ image, _, _, _ in
                tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
            }*/
        } else {
            
            cell.artistImageView.image = placeholder
        }
        
        
        return cell
    }
    
    // MARK: Private Functions
    
    private func loadArtists() {
        serviceModel.getTopArtists(onPage: 1, withLimit: 50) {
            data, error in
            if let err = error {
                NSLog("Error: \(err)")
            } else {
                self.artists = data
                self.tableView.reloadData()
            }
        }
    }
}
