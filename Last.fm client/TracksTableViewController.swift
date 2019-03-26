//
//  TracksTableViewController.swift
//  Last.fm client
//
//  Created by student on 3/26/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import SDWebImage

class TracksTableViewController: UITableViewController, UISearchBarDelegate {

    // MARK: Properties
    
    private var placeholder: UIImage?
    private let serviceModel = ServiceModel()
    private var tracks = [Track]()
    
    @IBOutlet weak var tracksSearchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let placeholder = UIImage(named: "Placeholder") {
            self.placeholder = placeholder
        } else {
            NSLog("Can't find placeholder")
        }
        
        tracksSearchBar.delegate = self
        loadTracks()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as? TrackTableViewCell else {
            
            fatalError("Unexpected type of cell")
        }
        
        let track = tracks[indexPath.row]
        
        cell.trackName.text = track.name
        cell.artistName.text = track.artistName
        
        if let largeImg = track.photoUrls["large"], let url = URL(string: largeImg) {
            
            cell.trackImageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: nil)
            /*{ image, _, _, _ in
             tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
             }*/
        } else {
            
            cell.trackImageView.image = placeholder
        }
        
        
        return cell
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchTracks(byName: searchBar.text!)
        view.endEditing(true)
    }
    
    // MARK: Private Functions
    
    private func loadTracks() {
        serviceModel.getTopTracks(onPage: 1, withLimit: 50) {
            data, error in
            if let err = error {
                NSLog("Error: \(err)")
            } else {
                self.tracks = data
                self.tableView.reloadData()
            }
        }
    }
    
    private func searchTracks(byName name: String) {
        serviceModel.searchTracks(byName: name, onPage: 1, withLimit: 50) {
            data, error in
            if let err = error {
                NSLog("Error: \(err)")
            } else {
                self.tracks = data
                self.tableView.reloadData()
            }
        }
    }

}
