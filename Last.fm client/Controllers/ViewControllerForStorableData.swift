//
//  TableViewForStorableData.swift
//  Last.fm client
//
//  Created by student on 4/17/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

typealias StorabeSource = ((_ closure: @escaping ([Storable], Error?) -> Void ) -> Void)

struct TableViewInfo {
    var data: [Storable]
    var navName: String
    var dataSource: StorabeSource
    
    mutating func appendStorableData(_ data: [Storable]){
        self.data += data
    }
}

class ViewControllerForStorableData: UIViewController, UITableViewDelegate,
UITableViewDataSource, UITabBarDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let apiService = APIService()
    private let preLoadCount = 3
    
    private var items = [UITabBarItem]()
    private var tableViewsInfo = [UITabBarItem:TableViewInfo]()
    private var activityIndicator = TableViewActivityIndicator()
    private var currData: [Storable] {
        get {
            guard let selected = tabBar.selectedItem, let info = tableViewsInfo[selected] else {
                return []
            }
            
            return info.data
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = activityIndicator
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "CustomCell")
        tabBar.items = items
        tabBar.selectedItem = items[0]
        if items.count > 1 {
            tabBar.isHidden = false
        }
        
        if let selected = tabBar.selectedItem, let info = tableViewsInfo[selected] {
            navigationItem.title = info.navName
        }
        
        if currData.isEmpty {
            getNextTracksFromSource()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    static func getInstanceFromStoryboard() -> ViewControllerForStorableData{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "VCForStorableData")
            as? ViewControllerForStorableData else {
                fatalError("Can't cast controller")
        }
        return controller
    }
    
    func setData(viewsInfo: [TableViewInfo]) {
        guard viewsInfo.count != 0 else {
            fatalError("Empty array!")
        }
        
        for info in viewsInfo {
            let item = UITabBarItem(title: info.navName, image: nil, selectedImage: nil)
            items.append(item)
            tableViewsInfo[item] = info
        }
    }
    
    // MARK: TabBar Delegate
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let selected = tabBar.selectedItem, let info = tableViewsInfo[selected] {
            navigationItem.title = info.navName
        }
        tableView.reloadData()
        if currData.isEmpty {
            getNextTracksFromSource()
        }
        else {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    // MARK: Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as?
            CustomTableViewCell else {
                fatalError("Unexpected type of cell")
        }
        
        cell.fillCell(withStorableData: currData[indexPath.row], isWithImg: true)
        
        if isStartLoadNextPage(currRow: indexPath.row) {
            getNextTracksFromSource()
        }
        
        return cell
    }
    
    // MARK: TableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushInfoViewController(withStoreableData: currData[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Private Methods
    
    private func isStartLoadNextPage(currRow: Int) -> Bool {
        guard !activityIndicator.isLoading else {
            return false
        }
        
        if apiService.itemsPerPage > preLoadCount {
            return currRow + 1 == currData.count - preLoadCount
        } else {
            return currRow + 1 == currData.count
        }
    }
    
    private func getNextTracksFromSource() {
        guard let currItem = tabBar.selectedItem, let info = tableViewsInfo[currItem] else {
            fatalError()
        }
        
        activityIndicator.showAndAnimate()
        info.dataSource { data, error in
            
            if let err = error {
                NSLog("Error: \(err)")
                
            } else {
                self.tableViewsInfo[currItem]?.appendStorableData(data)
                self.tableView.reloadData()
            }
            self.activityIndicator.hideAndStop()
        }
        
    }
    
    private func pushInfoViewController(withStoreableData value: Storable) {
        let viewController = InfoViewController.getInstanceFromStoryboard()
        viewController.setStoreableData(value)
        navigationController?.pushViewController(viewController, animated: true)
    }

}
