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
        let tvc1 = TableViewControllerForStorableData(representationMode: .artist, navName: "Top Atrists",
                                                      dataSource: apiService.getTopArtistsClosure())
        let tvc2 = TableViewControllerForStorableData(representationMode: .track, navName: "Top Tracks",
                                                      dataSource: apiService.getTopTracksClosure())
        let item1 = UINavigationController(rootViewController: tvc1)
        let item2 = UINavigationController(rootViewController: tvc2)
        let icon1 = UITabBarItem(title: "Top Artists", image: nil, selectedImage: nil)
        let icon2 = UITabBarItem(title: "Top Tracks", image: nil, selectedImage: nil)
        item1.tabBarItem = icon1
        item2.tabBarItem = icon2
        self.viewControllers?.insert(contentsOf: [item1,item2], at: 0)
    }

}
