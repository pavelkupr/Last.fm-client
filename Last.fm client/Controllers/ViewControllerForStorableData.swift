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
    mutating func rewriteStorableData(_ data: [Storable]){
        self.data = data
    }
}

class ViewControllerForStorableData: UIViewController, UITableViewDelegate,
UITableViewDataSource, CustomBarDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customBar: CustomBar!
    
    private let apiService = APIService()
    private let preLoadCount = 3
    var isPagingOn = true
    
    private var sections = [UIButton:TableViewInfo]()
    private var tableViewsInfo = [TableViewInfo]()
    private var activityIndicator = TableViewActivityIndicator()
    private var currData: [Storable] {
        get {
            guard let selected = customBar.getSelected(), let info = sections[selected] else {
                return []
            }
            
            return info.data
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = activityIndicator
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "CustomCell")
        
        var items = [UIButton]()
        
        for info in tableViewsInfo {
            let button = UIButton()
            button.setTitle(info.navName, for: .normal)
            sections[button] = info
            items.append(button)
        }
        
        customBar.setButtons(withItems: items)
        
        if customBar.itemsCount <= 1 {
            customBar.isHidden = true
        }
        
        if let selected = customBar.getSelected(), let info = sections[selected] {
            navigationItem.title = info.navName
        }
        
        if currData.isEmpty {
            getDataFromSource()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isPagingOn {
            tableView.reloadData()
        } else {
            getDataFromSource()
        }
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
        
        tableViewsInfo = viewsInfo
    }
    
    // MARK: CustomBar Delegate
    
    func customBarSelectedDidChange(button: UIButton) {
        if let info = sections[button] {
            navigationItem.title = info.navName
        }
        
        tableView.reloadData()
        if currData.isEmpty {
            getDataFromSource()
        }
        else {
            if !isPagingOn {
                getDataFromSource()
            }
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
            getDataFromSource()
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
        guard isPagingOn && !activityIndicator.isLoading else {
            return false
        }
        
        if currData.count > preLoadCount {
            return currRow + 1 == currData.count - preLoadCount
        } else {
            return currRow + 1 == currData.count
        }
    }
    
    private func getDataFromSource() {
        guard let currItem = customBar.getSelected(), let info = sections[currItem] else {
            fatalError()
        }
        
        activityIndicator.showAndAnimate()
        info.dataSource { data, error in
            
            if let err = error {
                NSLog("Error: \(err)")
                if (err as NSError).code != 400 {
                    self.activityIndicator.hideAndStop()
                }
            
            } else {
                if self.isPagingOn {
                    self.sections[currItem]?.appendStorableData(data)
                } else {
                    self.sections[currItem]?.rewriteStorableData(data)
                }
                self.tableView.reloadData()
                self.activityIndicator.hideAndStop()
            }
        }
        
    }
    
    private func pushInfoViewController(withStoreableData value: Storable) {
        let viewController = InfoViewController.getInstanceFromStoryboard()
        viewController.setStoreableData(value)
        navigationController?.pushViewController(viewController, animated: true)
    }

}
