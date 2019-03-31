//
//  SearchTableViewController.swift
//  Last.fm client
//
//  Created by student on 3/28/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private enum SectionItem {
        
        case artists([Artist])
        case tracks([Track])
        case resentSearches([String])
        
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
    
    private let sectionHeaderHeight = CGFloat(30)
    private let serviceModel = ServiceModel()
    
    private var isResentMode = true
    private var searchModeSectionsInfo = [SectionItem.artists([]), SectionItem.tracks([])]
    private var recentModeSectionInfo = [SectionItem.resentSearches([])]
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var cancelButtonConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        searchBar.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return isResentMode ? recentModeSectionInfo.count : searchModeSectionsInfo.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isResentMode {
            switch recentModeSectionInfo[section] {
            case .resentSearches(let data):
                return data.count
            default:
                fatalError("Unexpected type of section")
            }
            
        }
        else {
            switch searchModeSectionsInfo[section] {
            case .artists(let data):
                return data.count
            case .tracks(let data):
                return data.count
            default:
                fatalError("Unexpected type of section")
            }
            
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var currCell: UITableViewCell
        
        if isResentMode {
            switch recentModeSectionInfo[indexPath.section] {
            case .resentSearches(let data):
                guard let cell = searchTableView.dequeueReusableCell(withIdentifier: "RecentCell", for: indexPath) as?
                    RecentTableViewCell else {
                        fatalError("Unexpected type of cell")
                }
                cell.fillCell(withSearch: data[indexPath.row])
                currCell = cell
            default:
                fatalError("Unexpected type of section")
            }
            
        }
        else {
            switch searchModeSectionsInfo[indexPath.section] {
            case .artists(let data):
                guard let cell = searchTableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath) as?
                    ArtistTableViewCell else {
                        fatalError("Unexpected type of cell")
                }
                cell.fillCell(withArtist: data[indexPath.row])
                currCell = cell
                
            case .tracks(let data):
                guard let cell = searchTableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as?
                    TrackTableViewCell else {
                        fatalError("Unexpected type of cell")
                }
                cell.fillCell(withTrack: data[indexPath.row])
                currCell = cell
            default:
                fatalError("Unexpected type of section")
            }
            
        }
        
        return currCell
    }
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerName = ""
        
        if isResentMode {
            headerName = recentModeSectionInfo[section].getStringDefinition()
        }
        else  {
            headerName = searchModeSectionsInfo[section].getStringDefinition()
        }
        
        return SectionHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: sectionHeaderHeight), nameOfHeader: headerName)
        
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        let textForSearch = searchBar.text!
        searchBar.text = ""
        self.isResentMode = false
        
        searchArtists(byName: textForSearch)
        searchTracks(byName: textForSearch)
        
        cancelButtonConstraint.constant = 100
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        for index in 0..<recentModeSectionInfo.count {
            switch recentModeSectionInfo[index] {
            case .resentSearches(var data):
                if !data.contains(textForSearch) {
                    data.append(textForSearch)
                    recentModeSectionInfo[index] = .resentSearches(data)
                }
            default:
                break
            }
        }
        
    }
    
    // MARK: Actions
    
    @IBAction func cancelSearchMode(_ sender: UIButton) {
        cancelButtonConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        self.isResentMode = true
        searchTableView.reloadData()
    }
    
    
    // MARK: Private Methods
    
    private func searchArtists(byName name: String) {
        serviceModel.searchArtists(byName: name, onPage: 1, withLimit: 3) { data, error in
            
            if let err = error {
                NSLog("Error: \(err)")
                
            } else {
                for index in 0..<self.searchModeSectionsInfo.count {
                    switch self.searchModeSectionsInfo[index] {
                    case .artists:
                        self.searchModeSectionsInfo[index] = .artists(data)
                        
                    default:
                        break
                    }
                }

                self.searchTableView.reloadData()
            }
        }
    }
    
    private func searchTracks(byName name: String) {
        serviceModel.searchTracks(byName: name, onPage: 1, withLimit: 3) { data, error in
            
            if let err = error {
                NSLog("Error: \(err)")
                
            } else {
                for index in 0..<self.searchModeSectionsInfo.count {
                    switch self.searchModeSectionsInfo[index] {
                    case .tracks:
                        self.searchModeSectionsInfo[index] = .tracks(data)
                        
                    default:
                        break
                    }
                }
                
                self.searchTableView.reloadData()
            }
        }
    }
}
