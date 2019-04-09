//
//  SearchTableViewController.swift
//  Last.fm client
//
//  Created by student on 3/28/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate,
UITableViewDelegate, UITableViewDataSource {

    private enum SectionItem {

        case artists
        case tracks
        case resentSearches

        func getStringDefinition() -> String {
            switch self {
            case .artists:
                return "Artists"
            case .tracks:
                return "Tracks"
            case .resentSearches:
                return "Resent Searches"
            }
        }
    }

    // MARK: Properties

    private let searchInfoCount = 3
    private let sectionLabelShift: CGFloat = 20
    private let apiService = APIService()

    private var isResentMode = true
    private var searchModeSectionsInfo: [(key: SectionItem, value: [Storable])] =
        [(.tracks, [Track]()), (.artists, [Artist]())]
    private var recentModeSectionsInfo: [(key: SectionItem, value: [Storable])] =
        [(.resentSearches, [String]())]
    private var tracksSource: TrackSource?
    private var artistsSource: ArtistSource?

    private var activityIndicator: TableViewActivityIndicator?
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBarView: CustomSearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        searchTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "CustomCell")

        searchBarView.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        activityIndicator = TableViewActivityIndicator()
        searchTableView.tableFooterView = activityIndicator
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {

        return isResentMode ? recentModeSectionsInfo.count : searchModeSectionsInfo.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if isResentMode {
            return recentModeSectionsInfo[section].value.count

        } else {
            let count = searchModeSectionsInfo[section].value.count
            return count > searchInfoCount ? searchInfoCount : count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = searchTableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as?
            CustomTableViewCell else {
                fatalError("Unexpected type of cell")
        }

        if isResentMode {
            let data = recentModeSectionsInfo[indexPath.section].value[indexPath.row]
            cell.fillCell(withStorableData: data, isWithImg: false)

        } else {
            let data = searchModeSectionsInfo[indexPath.section].value[indexPath.row]
            cell.fillCell(withStorableData: data, isWithImg: true)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerName = ""
        var sectionHeader: HeaderView
        
        if isResentMode {
            headerName = recentModeSectionsInfo[section].key.getStringDefinition()
            sectionHeader = HeaderView(labelShift: sectionLabelShift, nameOfHeader: headerName)
            sectionHeader.moreButton.isHidden = true
        } else {
            headerName = searchModeSectionsInfo[section].key.getStringDefinition()
            sectionHeader = HeaderView(labelShift: sectionLabelShift, nameOfHeader: headerName)

            if searchModeSectionsInfo[section].value.count > searchInfoCount {
                switch searchModeSectionsInfo[section].key {
                case .artists:
                    sectionHeader.moreButton.addTarget(self, action: #selector(moreArtists(_:)), for: .touchUpInside)
                case .tracks:
                    sectionHeader.moreButton.addTarget(self, action: #selector(moreTracks(_:)), for: .touchUpInside)

                default:
                    break
                }
            }
        }

        return sectionHeader

    }

    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isResentMode {
            view.endEditing(true)
            searchBarView.text = ""
            search(recentModeSectionsInfo[indexPath.section].value[indexPath.row].mainInfo)
        } else {
            performSegue(withIdentifier: "ShowInfo", sender: tableView.cellForRow(at: indexPath))
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: UISearchBarDelegate

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.resignFirstResponder()
        let textForSearch = searchBar.text!.trimmingCharacters(in: .whitespaces)
        searchBar.text = ""

        if textForSearch != "" {
            search(textForSearch)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarView.setShowsCancelButton(false, animated: true)
        self.isResentMode = true
        searchTableView.reloadData()
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        super.prepare(for: segue, sender: sender)

        switch segue.identifier ?? "" {

        case "ShowInfo":
            guard let infoVC = segue.destination as? InfoViewController else {
                fatalError("Unexpected destination")
            }

            guard let cell = sender as? CustomTableViewCell else {
                fatalError("Unexpected sender")
            }

            guard let artistId = searchTableView.indexPath(for: cell) else {
                fatalError("Cell: \(cell) is not in the tableView")
            }

            prepareInfoView(infoVC, index: artistId)

        case "MoreArtists":
            guard let artistsTVC = segue.destination as? ArtistsTableViewController else {
                fatalError("Unexpected destination")
            }
            prepareArtistsTableView(artistsTVC)

        case "MoreTracks":
            guard let tracksTVC = segue.destination as? TracksTableViewController else {
                fatalError("Unexpected destination")
            }
            prepareTracksTableView(tracksTVC)

        default:
            fatalError("Unexpected segue")

        }
    }

    // MARK: Actions

    @objc func moreArtists(_ sender: UIButton) {

        performSegue(withIdentifier: "MoreArtists", sender: self)
    }

    @objc func moreTracks(_ sender: UIButton) {

        performSegue(withIdentifier: "MoreTracks", sender: self)
    }

    // MARK: Private Methods

    private func search(_ info: String) {
        
        for index in 0..<searchModeSectionsInfo.count {
            switch searchModeSectionsInfo[index].key {
            case .artists:
                searchModeSectionsInfo[index].value = []
            case .tracks:
                searchModeSectionsInfo[index].value = []
            default:
                break
            }
        }
        
        searchTracks(byName: info)
        searchArtists(byName: info)
        self.isResentMode = false
        searchBarView.setShowsCancelButton(true, animated: true)

        for index in 0..<recentModeSectionsInfo.count {
            switch recentModeSectionsInfo[index].key {
            case .resentSearches:
                if !recentModeSectionsInfo[index].value.contains(where: { $0.mainInfo == info}) {
                    recentModeSectionsInfo[index].value.append(info)
                }

            default:
                break
            }
        }
    }

    private func searchArtists(byName name: String) {
        artistsSource = apiService.getSearchArtistsClosure(byName: name)

        activityIndicator?.showAndAnimate()
        artistsSource!(1) { data, error in

            if let err = error {
                NSLog("Error: \(err)")

            } else {
                for index in 0..<self.searchModeSectionsInfo.count {
                    switch self.searchModeSectionsInfo[index].key {
                    case .artists:
                        self.searchModeSectionsInfo[index].value = data

                    default:
                        break
                    }
                }

                self.searchTableView.reloadData()
                self.activityIndicator?.hideAndStop()
            }
        }
    }

    private func searchTracks(byName name: String) {
        tracksSource = apiService.getSearchTracksClosure(byName: name)

        activityIndicator?.showAndAnimate()
        tracksSource!(1) { data, error in

            if let err = error {
                NSLog("Error: \(err)")

            } else {
                for index in 0..<self.searchModeSectionsInfo.count {
                    switch self.searchModeSectionsInfo[index].key {
                    case .tracks:
                        self.searchModeSectionsInfo[index].value = data

                    default:
                        break
                    }
                }

                self.searchTableView.reloadData()
                self.activityIndicator?.hideAndStop()
            }
        }
    }

    private func prepareInfoView(_ infoVC: InfoViewController, index: IndexPath) {

            switch searchModeSectionsInfo[index.section].key {
            case .artists:
                infoVC.setStoreableData(searchModeSectionsInfo[index.section].value[index.row], mode: .artist)
            case .tracks:
                infoVC.setStoreableData(searchModeSectionsInfo[index.section].value[index.row], mode: .track)
            default:
                break
            }

    }

    private func prepareArtistsTableView(_ artistsTVC: ArtistsTableViewController) {
        for element in searchModeSectionsInfo {
            switch element.key {
            case .artists:
                guard let source = artistsSource else {
                    fatalError("Source is empty")
                }
                artistsTVC.setCustomStartInfo(withSource: source, withName: "More Artists",
                                              withFirstPage: element.value)

            default:
                break
            }
        }
    }

    private func prepareTracksTableView(_ tracksTVC: TracksTableViewController) {
        for element in searchModeSectionsInfo {
            switch element.key {
            case .tracks:
                guard let source = tracksSource else {
                    fatalError("Source is empty")
                }
                tracksTVC.setCustomStartInfo(withSource: source, withName: "More Tracks",
                                             withFirstPage: element.value)

            default:
                break
            }
        }
    }
}
