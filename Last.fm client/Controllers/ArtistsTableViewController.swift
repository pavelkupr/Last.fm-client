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

    private let apiService = APIService()
    private let preLoadCount = 3

    private var nextPage = 1
    private var placeholder: UIImage?
    private var artists = [Artist]()
    private var customNavName: String?
    private var isTopChart = true
    private var activityIndicator: TableViewActivityIndicator!

    private lazy var dataSource = apiService.getTopArtistsClosure()

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator = TableViewActivityIndicator()
        tableView.tableFooterView = activityIndicator

        if let navName = customNavName {
            navigationItem.title = navName
        } else {
            navigationItem.title = "Top Artists"
        }

        if artists.count == 0 {
            getArtistsFromSource(onPage: nextPage)
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
        if isTopChart {
            cell.fillCell(withArtist: artists[indexPath.row], numInChart: indexPath.row + 1)
        } else {
            cell.fillCell(withArtist: artists[indexPath.row])
        }

        if isStartLoadNextPage(currRow: indexPath.row) {
            getArtistsFromSource(onPage: nextPage)
        }

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

    func setCustomStartInfo(withSource source: @escaping ArtistSource, withName name: String,
                            withFirstPage fisrstPage: [Artist]?) {
        customNavName = name
        dataSource = source
        isTopChart = false
        if let page = fisrstPage {
            artists = page
        }
    }

    // MARK: Private Functions

    private func isStartLoadNextPage(currRow: Int) -> Bool {
        guard !activityIndicator.isLoading else {
            return false
        }
        
        if apiService.itemsPerPage > preLoadCount {
            return currRow + 1 == artists.count - preLoadCount
        } else {
            return currRow + 1 == artists.count
        }
    }

    private func getArtistsFromSource(onPage page: Int) {
        activityIndicator.showAndAnimate()

        dataSource(page) { data, error in

            if let err = error {
                NSLog("Error: \(err)")

            } else {
                self.nextPage += 1
                self.artists += data
                self.tableView.reloadData()
            }
            self.activityIndicator.hideAndStop()
        }
    }

}
