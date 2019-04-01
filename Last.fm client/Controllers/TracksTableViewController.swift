//
//  TracksTableViewController.swift
//  Last.fm client
//
//  Created by student on 3/26/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class TracksTableViewController: UITableViewController {

    // MARK: Properties

    private var placeholder: UIImage?
    private let serviceModel = ServiceModel()
    var tracks = [Track]()
    var customNavName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navName = customNavName {
            navigationItem.title = navName
        }
        else {
            navigationItem.title = "Top Artists"
        }
        
        if tracks.count == 0 {
            loadTracks()
        }
    }

    // MARK: Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return tracks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as?
            TrackTableViewCell else {
            fatalError("Unexpected type of cell")
        }

        cell.fillCell(withTrack: tracks[indexPath.row])

        return cell
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier ?? "" {
            
        case "ShowInfo":
            guard let trackInfoVC = segue.destination as? TrackInfoViewController else {
                fatalError("Unexpected destination")
            }
            
            guard let cell = sender as? TrackTableViewCell else {
                fatalError("Unexpected sender")
            }
            
            guard let trackId = tableView.indexPath(for: cell)?.row else {
                fatalError("Cell: \(cell) is not in the tableView")
            }
            
            trackInfoVC.track =  tracks[trackId]
            
        default:
            fatalError("Unexpected segue")
            
        }
    }
    
    // MARK: Private Functions

    private func loadTracks() {
        serviceModel.getTopTracks(onPage: 1, withLimit: 50, closure: { data, error in

            if let err = error {
                NSLog("Error: \(err)")

            } else {
                self.tracks = data
                self.tableView.reloadData()
            }
        })
    }

    private func searchTracks(byName name: String) {
        serviceModel.searchTracks(byName: name, onPage: 1, withLimit: 50) { data, error in

            if let err = error {
                NSLog("Error: \(err)")

            } else {
                self.tracks = data
                self.tableView.reloadData()
            }
        }
    }

}
