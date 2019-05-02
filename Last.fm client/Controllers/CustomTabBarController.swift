//
//  CustomTabBarController.swift
//  Last.fm client
//
//  Created by student on 4/17/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    private let apiService = APIService()
    private let dataService = CoreDataService()
    private let geoService = GeoService()
    private var controllerForGeoButton: ViewControllerForStorableData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bundle = Bundle(for: type(of: self))
        let filledHeart = UIImage(named: "tabBarFilledHeart", in: bundle, compatibleWith: self.traitCollection)
        let emptyHeart = UIImage(named:"tabBarEmptyHeart", in: bundle, compatibleWith: self.traitCollection)
        
        let controller1 = createController1()
        let controller2 = createController2()
        let controller3 = createController3()
        
        let item1 = UINavigationController(rootViewController: controller1)
        let item2 = UINavigationController(rootViewController: controller2)
        let item3 = UINavigationController(rootViewController: controller3)
        
        item1.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        item2.tabBarItem = UITabBarItem(title: "Favorites", image: emptyHeart, selectedImage: filledHeart)
        item3.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        viewControllers = [item1, item2, item3]
    }
    
    private func createController1() -> UIViewController {
        let controller = ViewControllerForStorableData.getInstanceFromStoryboard()
        controller.setData(viewsInfo: geoService.getLocationRelatedTop(), header: geoService.getChartsHeaderWithCountryCode())
        
        let btn = CustomButton()
        btn.buttonType = .Geo
        btn.buttonColor = view.tintColor
        btn.button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
        controller.rightNavButton = btn
        controllerForGeoButton = controller
        
        return controller
    }
    
    private func createController2() -> UIViewController {
        let controller = ViewControllerForStorableData.getInstanceFromStoryboard()
        controller.setData(viewsInfo: [TableViewInfo(data: [], navName: "Favorite Artists", dataSource: dataService.getFavoriteArtistsClosure()),
                                       TableViewInfo(data: [], navName: "Favorite Tracks", dataSource: dataService.getFavoriteTracksClosure())],
                                       header: "Favorites")
        controller.isPagingOn = false
        
        return controller
    }
    
    private func createController3() -> UIViewController {
        let controller = SearchViewController.getInstanceFromStoryboard()
        
        return controller
    }
    
    @objc private func buttonTapped(button: UIButton) {
        let viewController = GoogleMapViewController.getInstanceFromStoryboard()
        viewController.associatedTVC = controllerForGeoButton
        controllerForGeoButton?.navigationController?.pushViewController(viewController, animated: true)
    }
}
