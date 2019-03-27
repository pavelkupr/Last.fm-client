//
//  ArtistsTableViewController.swift
//  Last.fm client
//
//  Created by student on 3/25/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class ArtistsTableViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: Properties
    
    private var placeholder: UIImage?
    private let serviceModel = ServiceModel()
    private var artists = [Artist]()
    
    @IBOutlet weak var artistsSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let placeholder = UIImage(named: "Placeholder") {
            self.placeholder = placeholder
        } else {
            NSLog("Can't find placeholder")
        }
        
        artistsSearchBar.delegate = self
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
        
        cell.fillCell(withArtist: artists[indexPath.row], withPlaceholder: placeholder)
        
        return cell
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchArtists(byName: searchBar.text!)
        view.endEditing(true)
    }
    
    //MARK: Navigation
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "ShowInfo":
            guard let artistInfoVC = segue.destination as? ArtistInfoViewController else {
                fatalError("Unexpected destination")
            }
            
            guard let cell = sender as? ArtistTableViewCell else {
                fatalError("Unexpected sender")
            }
            
            guard let artistId = tableView.indexPath(for: cell)?.row else {
                fatalError("Cell: \(cell) is not in the tableView")
            }
            
            artistInfoVC.artist =  artists[artistId]
            
        default:
            fatalError("Unexpected segue")
            
        }
    }
    
    // MARK: Actions
    
    
    
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
    
    private func searchArtists(byName name: String) {
        serviceModel.searchArtists(byName: name, onPage: 1, withLimit: 50) {
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
