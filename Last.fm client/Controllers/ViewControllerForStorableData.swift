//
//  TableViewForStorableData.swift
//  Last.fm client
//
//  Created by student on 4/17/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

typealias StorabeSource = ((_ closure: @escaping ([Storable], Error?) -> Void ) -> Void)

class ViewControllerForStorableData: UIViewController, UITableViewDelegate,
UITableViewDataSource {
    
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    private let apiService = APIService()
    private let preLoadCount = 3
    
    private var storableData = [Storable]()
    private var representationMode = DataRepresentationMode.none
    private var activityIndicator = TableViewActivityIndicator()
    private var navName: String?
    private var dataSource: StorabeSource?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = activityIndicator
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "CustomCell")

        navigationItem.title = navName
        
        if storableData.isEmpty {
            getNextTracksFromSource()
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
    
    func setData(representationMode: DataRepresentationMode, navName: String, dataSource: @escaping StorabeSource, data: [Storable]? = nil) {
        
        self.representationMode = representationMode
        self.navName = navName
        self.dataSource = dataSource
        
        if let data = data {
            self.storableData = data
        }
        
    }
    
    // MARK: Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return storableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as?
            CustomTableViewCell else {
                fatalError("Unexpected type of cell")
        }
        
        cell.fillCell(withStorableData: storableData[indexPath.row], isWithImg: true)
        
        if isStartLoadNextPage(currRow: indexPath.row) {
            getNextTracksFromSource()
        }
        
        return cell
    }
    
    // MARK: TableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushInfoViewController(withStoreableData: storableData[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Private Methods
    
    private func isStartLoadNextPage(currRow: Int) -> Bool {
        guard !activityIndicator.isLoading else {
            return false
        }
        
        if apiService.itemsPerPage > preLoadCount {
            return currRow + 1 == storableData.count - preLoadCount
        } else {
            return currRow + 1 == storableData.count
        }
    }
    
    private func getNextTracksFromSource() {
        if let source = dataSource {
            activityIndicator.showAndAnimate()
            
            source { data, error in
                
                if let err = error {
                    NSLog("Error: \(err)")
                    
                } else {
                    let convert: [Storable] = data
                    self.storableData += convert
                    self.tableView.reloadData()
                }
                self.activityIndicator.hideAndStop()
            }
        }
    }
    
    private func pushInfoViewController(withStoreableData value: Storable) {
        let viewController = InfoViewController.getInstanceFromStoryboard()
        viewController.setStoreableData(value, mode: representationMode)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
