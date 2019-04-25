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

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBarView: CustomSearchBar!

    private let searchInfoCount = 3
    private let sectionLabelShift: CGFloat = 20
    private let apiService = APIService()
    private let userDefaultsService = UserDefaultsService()
    
    private var activityIndicator = TableViewActivityIndicator()
    private var isResentMode = true
    private var searchModeSectionsInfo: [(key: SectionItem, value: [Storable])] =
        [(.tracks, [Track]()), (.artists, [Artist]())]
    private var recentModeSectionsInfo: [(key: SectionItem, value: [Storable])] =
        [(.resentSearches, [String]())]
    
    private var currSearchRequest: String?
    private var tracksSource: TrackSource?
    private var artistsSource: ArtistSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        searchTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "CustomCell")
        
        searchBarView.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.tableFooterView = activityIndicator
        
        for index in 0..<recentModeSectionsInfo.count where
           recentModeSectionsInfo[index].key == .resentSearches {
            recentModeSectionsInfo[index].value = userDefaultsService.getSearchRequests()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTableView.reloadData()
    }
    
    static func getInstanceFromStoryboard() -> SearchViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "SearchController")
            as? SearchViewController else {
                fatalError("Can't cast controller")
        }
        return controller
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
        let sectionHeader = HeaderView()
        sectionHeader.shift = sectionLabelShift
        sectionHeader.isWithBorder = true
        
        if isResentMode {
            sectionHeader.headerName.text = recentModeSectionsInfo[section].key.getStringDefinition()
            sectionHeader.moreButton.isHidden = true
        } else {
            sectionHeader.headerName.text = searchModeSectionsInfo[section].key.getStringDefinition()
            sectionHeader.isHidden = searchModeSectionsInfo[section].value.isEmpty

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
            pushInfoViewWithData(atIndex: indexPath)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if isResentMode && editingStyle == .delete {
            for index in 0..<recentModeSectionsInfo.count where
                recentModeSectionsInfo[index].key == recentModeSectionsInfo[indexPath.section].key {
                    
                recentModeSectionsInfo[index].value.remove(at: indexPath.row)
                userDefaultsService.saveSearchRequests(requests: recentModeSectionsInfo[index].value)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    // MARK: UITableViewDragDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBarView.resignFirstResponderAndShowCancelButton()
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
        currSearchRequest = nil
        searchTableView.reloadData()
    }

    // MARK: Actions
    
    @objc func moreArtists(_ sender: UIButton) {
        
        for element in searchModeSectionsInfo where element.key == .artists {
            guard let searchRequest = currSearchRequest else {
                fatalError("Search request is empty")
            }
            let tvc = ViewControllerForStorableData.getInstanceFromStoryboard()
            let source = apiService.getSearchArtistsClosure(byName: searchRequest, withStartPage: 2)
            tvc.setData(viewsInfo: [TableViewInfo(data: element.value, navName: "More Artists", dataSource: source)])
            navigationController?.pushViewController(tvc, animated: true)
        }
    }

    @objc func moreTracks(_ sender: UIButton) {
        
        for element in searchModeSectionsInfo where element.key == .tracks {
            guard let searchRequest = currSearchRequest else {
                fatalError("Search request is empty")
            }
            let tvc = ViewControllerForStorableData.getInstanceFromStoryboard()
            let source = apiService.getSearchTracksClosure(byName: searchRequest, withStartPage: 2)
            tvc.setData(viewsInfo: [TableViewInfo(data: element.value, navName: "More Tracks", dataSource: source)])
            navigationController?.pushViewController(tvc, animated: true)
        }
    }

    // MARK: Private Methods

    private func search(_ info: String) {

        for index in 0..<searchModeSectionsInfo.count {
            searchModeSectionsInfo[index].value = []
        }
        currSearchRequest = info
        searchTracks(byName: info)
        searchArtists(byName: info)

        self.isResentMode = false
        searchBarView.setShowsCancelButton(true, animated: true)

        for index in 0..<recentModeSectionsInfo.count {
            if recentModeSectionsInfo[index].key == .resentSearches &&
                !recentModeSectionsInfo[index].value.contains(where: {$0.mainInfo == info}) {
                recentModeSectionsInfo[index].value.append(info)
                userDefaultsService.saveSearchRequests(requests: recentModeSectionsInfo[index].value)
            }
        }
    }

    private func searchArtists(byName name: String) {
        artistsSource = apiService.getSearchArtistsClosure(byName: name)

        activityIndicator.showAndAnimate()
        artistsSource! { data, error in

            if let err = error {
                NSLog("Error: \(err)")

            } else {
                for index in 0..<self.searchModeSectionsInfo.count
                    where self.searchModeSectionsInfo[index].key == .artists {
                    self.searchModeSectionsInfo[index].value = data
                }

                self.searchTableView.reloadData()
                self.activityIndicator.hideAndStop()
            }
        }
    }

    private func searchTracks(byName name: String) {
        tracksSource = apiService.getSearchTracksClosure(byName: name)

        activityIndicator.showAndAnimate()
        tracksSource! { data, error in

            if let err = error {
                NSLog("Error: \(err)")

            } else {
                for index in 0..<self.searchModeSectionsInfo.count
                    where self.searchModeSectionsInfo[index].key == .tracks {
                    self.searchModeSectionsInfo[index].value = data
                }

                self.searchTableView.reloadData()
                self.activityIndicator.hideAndStop()
            }
        }
    }

    private func pushInfoViewWithData(atIndex index: IndexPath) {
        
        let viewController = InfoViewController.getInstanceFromStoryboard()
        viewController.setStoreableData(searchModeSectionsInfo[index.section].value[index.row])
        navigationController?.pushViewController(viewController, animated: true)
    }
}
