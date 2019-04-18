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
        let controller2 = ViewControllerForStorableData.getInstanceFromStoryboard()
        let searchController = SearchViewController.getInstanceFromStoryboard()
        controller1.setData(representationMode: .artist, navName: "Top Atrists",
                            dataSource: apiService.getTopArtistsClosure())
        controller2.setData(representationMode: .track, navName: "Top Tracks",
                            dataSource: apiService.getTopTracksClosure())
        
        let item1 = UINavigationController(rootViewController: controller1)
        let item2 = UINavigationController(rootViewController: controller2)
        let item3 = UINavigationController(rootViewController: searchController)
        item1.tabBarItem = UITabBarItem(title: "Top Artists", image: nil, selectedImage: nil)
        item2.tabBarItem = UITabBarItem(title: "Top Tracks", image: nil, selectedImage: nil)
        item3.tabBarItem = UITabBarItem(title: "Search", image: nil, selectedImage: nil)
        viewControllers = [item1, item2, item3]
    }
    
}
