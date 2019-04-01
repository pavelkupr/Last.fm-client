//
//  ArtistsTableViewController.swift
//  Last.fm client
//
//  Created by student on 3/25/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class ArtistsTableViewController: UITableViewController {

    // MARK: Properties

    private var placeholder: UIImage?
    private let serviceModel = ServiceModel()
    var artists = [Artist]()
    var customNavName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navName = customNavName {
            navigationItem.title = navName
        }
        else {
            navigationItem.title = "Top Tracks"
        }
        
        if artists.count == 0 {
            loadArtists()
        }
    }

    // MARK: Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return artists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath) as?
            ArtistTableViewCell else {

            fatalError("Unexpected type of cell")
        }

        cell.fillCell(withArtist: artists[indexPath.row])

        return cell
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier ?? "" {
            
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
        serviceModel.getTopArtists(onPage: 1, withLimit: 50) { data, error in

            if let err = error {
                NSLog("Error: \(err)")

            } else {
                self.artists = data
                self.tableView.reloadData()
            }
        }
    }

}
