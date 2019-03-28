//
//  SearchTableViewController.swift
//  Last.fm client
//
//  Created by student on 3/28/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

struct SectionInfo<T: CaseIterable & Hashable> {
    
    var data: [T: [Any]] = [:]
    
    init() {
        for value in T.allCases {
            data[value] = [Any]()
        }
    }
    
    mutating func replaceData(withKey key: T, byValue value: [Any]) {
        data[key] = value
    }
}

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private enum SearchItems: Int, CaseIterable {
        case artists = 0, tracks
        
        func getStringDefinition() -> String {
            switch self {
            case .artists:
                return "Artists"
            case .tracks:
                return "Tracks"
            }
        }
    }
    
    private enum RecentItems: Int, CaseIterable {
        case resentSearches = 0
        
        func getStringDefinition() -> String {
            switch self {
            case .resentSearches:
                return "Resent Searches"
            }
        }
    }
    
    // MARK: Properties
    
    private let sectionHeaderHeight = CGFloat(30)
    
    private var isResentMode = true
    private var searchSectionInfo = SectionInfo<SearchItems>()
    private var recentSectionInfo = SectionInfo<RecentItems>()
    private var serviceModel = ServiceModel()
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return isResentMode ? RecentItems.allCases.count : SearchItems.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isResentMode, let tableSection = RecentItems(rawValue: section), let data = recentSectionInfo.data[tableSection] {
            return data.count
            
        } else if !isResentMode, let tableSection = SearchItems(rawValue: section), let data = searchSectionInfo.data[tableSection] {
            return data.count
            
        } else {
            fatalError("Unexpected sections")
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var currData: Any
        var currCell: FillableCell
        
        if isResentMode, let tableSection = RecentItems(rawValue: indexPath.section), let data = recentSectionInfo.data[tableSection] {
            currData = data[indexPath.row]
            switch tableSection {
                
            case .resentSearches:
                currCell = getFillableCell(withIdentifier: "RecentCell", for: indexPath)
            } 
            
        } else if !isResentMode, let tableSection = SearchItems(rawValue: indexPath.section), let data = searchSectionInfo.data[tableSection] {
            currData = data[indexPath.row]
            switch tableSection {
                
            case .artists:
                currCell = getFillableCell(withIdentifier: "ArtistCell", for: indexPath)
                
            case .tracks:
                currCell = getFillableCell(withIdentifier: "TrackCell", for: indexPath)
            }
            
        } else {
            fatalError("Unexpected sections")
        }
        
        currCell.fillCell(withInstance: currData)
        
        return currCell
    }
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: sectionHeaderHeight))
        view.backgroundColor = UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        //UIColor(red: 253.0/255.0, green: 240.0/255.0, blue: 196.0/255.0, alpha: 1)
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.bounds.width-10, height: sectionHeaderHeight))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.black
        if isResentMode, let tableSection = RecentItems(rawValue: section) {
            label.text = tableSection.getStringDefinition()
        } else if !isResentMode, let tableSection = SearchItems(rawValue: section) {
            label.text = tableSection.getStringDefinition()
        }
        
        view.addSubview(label)
        return view
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchArtists(byName: searchBar.text!)
        view.endEditing(true)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Private Methods
    
    private func getFillableCell(withIdentifier identifier: String, for index: IndexPath) -> FillableCell{
        
        guard let cell = searchTableView.dequeueReusableCell(withIdentifier: identifier, for: index) as?
            FillableCell else {
                fatalError("Unexpected type of cell")
        }
        
        return cell
    }
    
    private func searchArtists(byName name: String) {
        serviceModel.searchArtists(byName: name, onPage: 1, withLimit: 3) { data, error in
            
            if let err = error {
                NSLog("Error: \(err)")
                
            } else {
                self.searchSectionInfo.replaceData(withKey: SearchViewController.SearchItems.artists, byValue: data)
                self.isResentMode = false
                self.searchTableView.reloadData()
                
            }
        }
    }
}
