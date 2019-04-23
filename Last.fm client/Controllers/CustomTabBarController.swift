//
//  CustomTabBarController.swift
//  Last.fm client
//
//  Created by student on 4/17/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apiService = APIService()
        let controller1 = ViewControllerForStorableData.getInstanceFromStoryboard()
        let searchController = SearchViewController.getInstanceFromStoryboard()
        controller1.setData(viewsInfo: [TableViewInfo(data: [], navName: "Top Artists", dataSource: apiService.getTopArtistsClosure()),
                                        TableViewInfo(data: [], navName: "Top Tracks", dataSource: apiService.getTopTracksClosure())])
        let item1 = UINavigationController(rootViewController: controller1)
        let item2 = UINavigationController(rootViewController: searchController)
        item1.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        item2.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        viewControllers = [item1, item2]
    }
    
}
