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
    private var placeholder: UIImage?
    private var artists = [Storable]()
    private var customNavName: String?
    private var isTopChart = true
    private var activityIndicator: TableViewActivityIndicator!

    private lazy var dataSource = apiService.getTopArtistsClosure()

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator = TableViewActivityIndicator()
        tableView.tableFooterView = activityIndicator
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "ArtistCell")
        if let navName = customNavName {
            navigationItem.title = navName
        } else {
            navigationItem.title = "Top Artists"
        }

        if artists.isEmpty {
            getNextArtistsFromSource()
        }
    }

    // MARK: Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return artists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath) as?
            CustomTableViewCell else {

            fatalError("Unexpected type of cell")
        }

        cell.fillCell(withStorableData: artists[indexPath.row], isWithImg: true)

        if isStartLoadNextPage(currRow: indexPath.row) {
            getNextArtistsFromSource()
        }

        return cell
    }

    // MARK: TableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowInfo", sender: tableView.cellForRow(at: indexPath))
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        super.prepare(for: segue, sender: sender)

        switch segue.identifier ?? "" {

        case "ShowInfo":
            guard let artistInfoVC = segue.destination as? InfoViewController else {
                fatalError("Unexpected destination")
            }

            guard let cell = sender as? CustomTableViewCell else {
                fatalError("Unexpected sender")
            }

            guard let artistId = tableView.indexPath(for: cell)?.row else {
                fatalError("Cell: \(cell) is not in the tableView")
            }

            artistInfoVC.setStoreableData(artists[artistId], mode: .artist)

        default:
            fatalError("Unexpected segue")

        }
    }

    func setCustomStartInfo(withSource source: @escaping ArtistSource, withName name: String,
                            withLoadedData loadedData: [Storable]?) {
        customNavName = name
        dataSource = source
        isTopChart = false
        
        if let data = loadedData {
            artists = data
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

    private func getNextArtistsFromSource() {
        activityIndicator.showAndAnimate()

        dataSource { data, error in

            if let err = error {
                NSLog("Error: \(err)")

            } else {
                let convert: [Storable] = data
                self.artists += convert
                self.tableView.reloadData()
            }
            self.activityIndicator.hideAndStop()
        }
    }

}
