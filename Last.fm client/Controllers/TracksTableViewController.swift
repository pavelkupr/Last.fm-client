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

    private let apiService = APIService()
    private let preLoadCount = 3

    private var nextPage = 1
    private var placeholder: UIImage?
    private var tracks = [Track]()
    private var customNavName: String?
    private var isTopChart = true
    private var activityIndicator: TableViewActivityIndicator!

    private lazy var dataSource = apiService.getTopTracksClosure()

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator = TableViewActivityIndicator()
        tableView.tableFooterView = activityIndicator

        if let navName = customNavName {
            navigationItem.title = navName
        } else {
            navigationItem.title = "Top Tracks"
        }

        if tracks.count == 0 {
            getTracksFromSource(onPage: nextPage)
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
        if isTopChart {
            cell.fillCell(withTrack: tracks[indexPath.row], numInChart: indexPath.row + 1)
        } else {
            cell.fillCell(withTrack: tracks[indexPath.row])
        }
        if isStartLoadNextPage(currRow: indexPath.row) {
            getTracksFromSource(onPage: nextPage)
        }

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

    func setCustomStartInfo(withSource source: @escaping TrackSource, withName name: String,
                            withFirstPage fisrstPage: [Track]?) {
        customNavName = name
        dataSource = source
        isTopChart = false
        if let page = fisrstPage {
            tracks = page
            nextPage += 1
        }
    }

    // MARK: Private Methods

    private func isStartLoadNextPage(currRow: Int) -> Bool {
        guard !activityIndicator.isLoading else {
            return false
        }
        
        if apiService.itemsPerPage > preLoadCount {
            return currRow + 1 == tracks.count - preLoadCount
        } else {
            return currRow + 1 == tracks.count
        }
    }

    private func getTracksFromSource(onPage page: Int) {
        activityIndicator.showAndAnimate()

        dataSource(page) { data, error in

            if let err = error {
                NSLog("Error: \(err)")

            } else {
                self.nextPage += 1
                self.tracks += data
                self.tableView.reloadData()
            }
            self.activityIndicator.hideAndStop()
        }
    }

}
