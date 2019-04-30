//
//  CustomTabBarController.swift
//  Last.fm client
//
//  Created by student on 4/17/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    var controllerForGeoButton: ViewControllerForStorableData?
    let apiService = APIService()
    let dataService = CoreDataService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bundle = Bundle(for: type(of: self))
        let filledHeart = UIImage(named: "tabBarFilledHeart", in: bundle, compatibleWith: self.traitCollection)
        let emptyHeart = UIImage(named:"tabBarEmptyHeart", in: bundle, compatibleWith: self.traitCollection)
        
        let controller1 = ViewControllerForStorableData.getInstanceFromStoryboard()
        let controller2 = ViewControllerForStorableData.getInstanceFromStoryboard()
        let searchController = SearchViewController.getInstanceFromStoryboard()
        
        controller1.setData(viewsInfo: [TableViewInfo(data: [], navName: "Top Artists", dataSource: apiService.getTopArtistsClosure()),
                                        TableViewInfo(data: [], navName: "Top Tracks", dataSource: apiService.getTopTracksClosure())])
        let btn = FavoriteButton()
        btn.button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
        controller1.rightNavButton = btn
        controllerForGeoButton = controller1
        
        controller2.setData(viewsInfo: [TableViewInfo(data: [], navName: "Favorite Artists", dataSource: dataService.getFavoriteArtistsClosure()),
                                        TableViewInfo(data: [], navName: "Favorite Tracks", dataSource: dataService.getFavoriteTracksClosure())])
        controller2.isPagingOn = false
        
        let item1 = UINavigationController(rootViewController: controller1)
        let item2 = UINavigationController(rootViewController: searchController)
        let item3 = UINavigationController(rootViewController: controller2)
        
        item1.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        item2.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        item3.tabBarItem = UITabBarItem(title: "Favorites", image: emptyHeart, selectedImage: filledHeart)
        viewControllers = [item1, item3, item2]
    }
    
    @objc private func buttonTapped(button: UIButton) {
        let viewController = GoogleMapViewController.getInstanceFromStoryboard()
        viewController.associatedTVC = controllerForGeoButton
        controllerForGeoButton?.navigationController?.pushViewController(viewController, animated: true)
    }
}
