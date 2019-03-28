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
    private var tracks = [Track]()
    
    override func viewDidLoad() {

        super.viewDidLoad()

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

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as?
            TrackTableViewCell else {
            fatalError("Unexpected type of cell")
        }

        cell.fillCell(withInstance: tracks[indexPath.row])

        return cell
    }

    // MARK: Private Functions

    private func loadTracks() {
        serviceModel.getTopTracks(onPage: 1, withLimit: 50) { data, error in

            if let err = error {
                NSLog("Error: \(err)")

            } else {
                self.tracks = data
                self.tableView.reloadData()
            }
        }
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
