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
        let tvc1 = TableViewControllerForStorableData.getTVCForStorableData()
        let tvc2 = TableViewControllerForStorableData.getTVCForStorableData()
        tvc1.setData(representationMode: .artist, navName: "Top Atrists",
                     dataSource: apiService.getTopArtistsClosure())
        tvc2.setData(representationMode: .track, navName: "Top Tracks",
                     dataSource: apiService.getTopTracksClosure())
        
        let item1 = UINavigationController(rootViewController: tvc1)
        let item2 = UINavigationController(rootViewController: tvc2)
        item1.tabBarItem = UITabBarItem(title: "Top Artists", image: nil, selectedImage: nil)
        item2.tabBarItem = UITabBarItem(title: "Top Tracks", image: nil, selectedImage: nil)
        self.viewControllers?.insert(contentsOf: [item1,item2], at: 0)
    }
    
}
